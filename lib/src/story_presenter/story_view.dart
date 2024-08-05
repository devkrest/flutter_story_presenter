import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/src/story_presenter/story_custom_view_wrapper.dart';
import '../story_presenter/story_view_indicator.dart';
import '../models/story_item.dart';
import '../models/story_view_indicator_config.dart';
import '../controller/flutter_story_controller.dart';
import '../story_presenter/image_story_view.dart';
import '../story_presenter/video_story_view.dart';
import '../story_presenter/web_story_view.dart';
import '../story_presenter/text_story_view.dart';
import '../utils/smooth_video_progress.dart';
import '../utils/story_utils.dart';
import 'package:video_player/video_player.dart';

typedef OnStoryChanged = void Function(int);
typedef OnCompleted = Future<void> Function();
typedef OnLeftTap = void Function();
typedef OnRightTap = void Function();
typedef OnDrag = void Function();
typedef OnItemBuild = Widget? Function(int, Widget);
typedef OnVideoLoad = void Function(VideoPlayerController?);
typedef OnSlideDown = void Function(DragUpdateDetails);
typedef OnSlideStart = void Function(DragStartDetails);

class FlutterStoryView extends StatefulWidget {
  const FlutterStoryView(
      {this.flutterStoryController,
      this.items = const [],
      this.onStoryChanged,
      this.onLeftTap,
      this.onRightTap,
      this.onCompleted,
      this.onPreviousCompleted,
      this.initialIndex = 0,
      this.storyViewIndicatorConfig,
      this.restartOnCompleted = true,
      this.onVideoLoad,
      this.headerWidget,
      this.footerWidget,
      this.onSlideDown,
      this.onSlideStart,
      super.key})
      : assert(initialIndex < items.length);

  /// List of StoryItem objects to display in the story view.
  final List<StoryItem> items;

  /// Controller for managing the current playing media.
  final FlutterStoryController? flutterStoryController;

  /// Callback function triggered whenever the story changes or the user navigates to the previous/next story.
  final OnStoryChanged? onStoryChanged;

  /// Callback function triggered when all items in the list have been played.
  final OnCompleted? onCompleted;

  /// Callback function triggered when all items in the list have been played.
  final OnCompleted? onPreviousCompleted;

  /// Callback function triggered when the user taps on the left half of the screen.
  final OnLeftTap? onLeftTap;

  /// Callback function triggered when the user taps on the right half of the screen.
  final OnRightTap? onRightTap;

  /// Callback function triggered when user drag downs the storyview.
  final OnSlideDown? onSlideDown;

  /// Callback function triggered when user starts drag downs the storyview.
  final OnSlideStart? onSlideStart;

  /// Indicates whether the story view should restart from the beginning after all items have been played.
  final bool restartOnCompleted;

  /// Index to start playing the story from initially.
  final int initialIndex;

  /// Configuration and styling options for the story view indicator.
  final StoryViewIndicatorConfig? storyViewIndicatorConfig;

  /// Callback function to retrieve the VideoPlayerController when it is initialized and ready to play.
  final OnVideoLoad? onVideoLoad;

  /// Widget to display user profile or other details at the top of the screen.
  final Widget? headerWidget;

  /// Widget to display text field or other content at the bottom of the screen.
  final Widget? footerWidget;

  @override
  State<FlutterStoryView> createState() => _FlutterStoryViewState();
}

class _FlutterStoryViewState extends State<FlutterStoryView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _currentProgressAnimation;
  int currentIndex = 0;
  bool isCurrentItemLoaded = false;
  double currentItemProgress = 0;
  VideoPlayerController? _currentVideoPlayer;
  double? storyViewHeight;

  @override
  void initState() {
    if (_animationController != null) {
      _animationController?.reset();
      _animationController?.dispose();
      _animationController = null;
    }
    _animationController = AnimationController(
      vsync: this,
    );
    currentIndex = widget.initialIndex;
    widget.flutterStoryController?.addListener(_storyControllerListener);
    _startStoryView();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _resumeMedia();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _pauseMedia();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    widget.flutterStoryController
      ?..removeListener(_storyControllerListener)
      ..dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Returns the current story item.
  StoryItem get currentItem => widget.items[currentIndex];

  /// Returns the configuration for the story view indicator.
  StoryViewIndicatorConfig get storyViewIndicatorConfig =>
      widget.storyViewIndicatorConfig ?? const StoryViewIndicatorConfig();

  /// Listener for the story controller to handle various story actions.
  void _storyControllerListener() {
    final controller = widget.flutterStoryController;
    final storyStatus = controller?.storyStatus;
    final jumpIndex = controller?.jumpIndex;

    if (storyStatus != null) {
      if (storyStatus.isPlay) {
        _resumeMedia();
      } else if (storyStatus.isMute || storyStatus.isUnMute) {
        _toggleMuteUnMuteMedia();
      } else if (storyStatus.isPause) {
        _pauseMedia();
      } else if (storyStatus.isPrevious) {
        _playPrevious();
      } else if (storyStatus.isNext) {
        _playNext();
      } else if (storyStatus.isPlayCustomWidget) {
        isCurrentItemLoaded = true;
        _startStoryCountdown();
      }
    }

    if (jumpIndex != null &&
        jumpIndex >= 0 &&
        jumpIndex < widget.items.length) {
      currentIndex = jumpIndex - 1;
      _playNext();
    }
  }

  /// Starts the story view.
  void _startStoryView() {
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    if (mounted) {
      setState(() {});
    }
  }

  /// Resets the animation controller and its listeners.
  void _resetAnimation() {
    _animationController?.reset();
    _animationController
      ?..removeListener(animationListener)
      ..removeStatusListener(animationStatusListener);
  }

  /// Initializes and starts the media playback for the current story item.
  void _playMedia() {
    isCurrentItemLoaded = false;
  }

  /// Resumes the media playback.
  void _resumeMedia() {
    _currentVideoPlayer?.play();
    if (_currentProgressAnimation != null) {
      _animationController?.forward(
        from: _currentProgressAnimation?.value,
      );
    }
  }

  /// Starts the countdown for the story item duration.
  void _startStoryCountdown() {
    _currentVideoPlayer?.addListener(videoListener);
    if (_currentVideoPlayer != null) {
      return;
    }

    _animationController ??= AnimationController(
      vsync: this,
    );

    _animationController?.duration =
        _currentVideoPlayer?.value.duration ?? currentItem.duration;

    _currentProgressAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController!)
          ..addListener(animationListener)
          ..addStatusListener(animationStatusListener);

    _animationController!.forward();
  }

  /// Listener for the video player's state changes.
  void videoListener() {
    final dur = _currentVideoPlayer?.value.duration.inMilliseconds;
    final pos = _currentVideoPlayer?.value.position.inMilliseconds;

    if (pos == dur) {
      _playNext();
      return;
    }

    if (_currentVideoPlayer?.value.isBuffering ?? false) {
      _animationController?.stop(canceled: false);
    }

    if (_currentVideoPlayer?.value.isPlaying ?? false) {
      if (_currentProgressAnimation != null) {
        _animationController?.forward(from: _currentProgressAnimation?.value);
      }
    }
  }

  /// Listener for the animation progress.
  void animationListener() {
    currentItemProgress = _animationController?.value ?? 0;
  }

  /// Listener for the animation status.
  void animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _playNext();
    }
  }

  /// Pauses the media playback.
  void _pauseMedia() {
    _currentVideoPlayer?.pause();
    _animationController?.stop(canceled: false);
  }

  /// Toggles mute/unmute for the media.
  void _toggleMuteUnMuteMedia() {
    if (_currentVideoPlayer != null) {
      final videoPlayerValue = _currentVideoPlayer!.value;
      if (videoPlayerValue.volume == 1) {
        _currentVideoPlayer!.setVolume(0);
      } else {
        _currentVideoPlayer!.setVolume(1);
      }
    }
  }

  /// Plays the next story item.
  void _playNext() async {
    if (widget.items.length == 1 &&
        _currentVideoPlayer != null &&
        widget.restartOnCompleted) {
      await widget.onCompleted?.call();

      /// In case of story length 1 with video, we won't initialise,
      /// instead we will loop the video
      return;
    }
    if (_currentVideoPlayer != null &&
        currentIndex != (widget.items.length - 1)) {
      /// Dispose the video player only in case of multiple story
      _currentVideoPlayer?.removeListener(videoListener);
      _currentVideoPlayer?.dispose();
      _currentVideoPlayer = null;
    }

    if (currentIndex == widget.items.length - 1) {
      await widget.onCompleted?.call();
      if (widget.restartOnCompleted) {
        currentIndex = 0;
        _resetAnimation();
        _startStoryView();
      }
      if (mounted) {
        setState(() {});
      }
      return;
    }

    currentIndex = currentIndex + 1;
    _resetAnimation();
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    if (mounted) {
      setState(() {});
    }
  }

  /// Plays the previous story item.
  void _playPrevious() {
    if (_currentVideoPlayer != null) {
      _currentVideoPlayer?.removeListener(videoListener);
      _currentVideoPlayer?.dispose();
      _currentVideoPlayer = null;
    }

    if (currentIndex == 0) {
      _resetAnimation();
      _startStoryCountdown();
      if (mounted) {
        setState(() {});
      }
      widget.onPreviousCompleted?.call();
      return;
    }

    _resetAnimation();
    currentIndex = currentIndex - 1;
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        if (currentItem.thumbnail != null) ...{
          currentItem.thumbnail!,
        },
        if (currentItem.storyItemType.isCustom &&
            currentItem.customWidget != null) ...{
          Positioned.fill(
            child: StoryCustomWidgetWrapper(
              child: currentItem.customWidget!(widget.flutterStoryController),
            ),
          ),
        },
        if (currentItem.storyItemType.isImage) ...{
          Positioned.fill(
            child: ImageStoryView(
              key: ValueKey('$currentIndex'),
              storyItem: currentItem,
              onImageLoaded: (isLoaded) {
                isCurrentItemLoaded = isLoaded;
                _startStoryCountdown();
              },
            ),
          ),
        },
        if (currentItem.storyItemType.isVideo) ...{
          Positioned.fill(
            child: VideoStoryView(
              storyItem: currentItem,
              key: ValueKey('$currentIndex'),
              looping: widget.items.length == 1 && widget.restartOnCompleted,
              onVideoLoad: (videoPlayer) {
                isCurrentItemLoaded = true;
                _currentVideoPlayer = videoPlayer;
                widget.onVideoLoad?.call(videoPlayer);
                _startStoryCountdown();
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
        },
        if (currentItem.storyItemType.isWeb) ...{
          Positioned.fill(
            child: WebStoryView(
              storyItem: currentItem,
              key: ValueKey('$currentIndex'),
              onWebViewLoaded: (controller, loaded) {
                isCurrentItemLoaded = loaded;
                if (loaded) {
                  _startStoryCountdown();
                }
                currentItem.webConfig?.onWebViewLoaded
                    ?.call(controller, loaded);
              },
            ),
          ),
        },
        if (currentItem.storyItemType.isText) ...{
          Positioned.fill(
            child: TextStoryView(
              storyItem: currentItem,
              key: ValueKey('$currentIndex'),
              onTextStoryLoaded: (loaded) {
                isCurrentItemLoaded = loaded;
                _startStoryCountdown();
              },
            ),
          ),
        },
        Align(
          alignment: storyViewIndicatorConfig.alignment,
          child: Padding(
            padding: storyViewIndicatorConfig.margin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _currentVideoPlayer != null
                    ? SmoothVideoProgress(
                        controller: _currentVideoPlayer!,
                        builder: (context, progress, duration, child) {
                          return StoryViewIndicator(
                            currentIndex: currentIndex,
                            currentItemAnimatedValue: progress.inMilliseconds /
                                duration.inMilliseconds,
                            totalItems: widget.items.length,
                            storyViewIndicatorConfig: storyViewIndicatorConfig,
                          );
                        })
                    : _animationController != null
                        ? AnimatedBuilder(
                            animation: _animationController!,
                            builder: (context, child) => StoryViewIndicator(
                              currentIndex: currentIndex,
                              currentItemAnimatedValue: currentItemProgress,
                              totalItems: widget.items.length,
                              storyViewIndicatorConfig:
                                  storyViewIndicatorConfig,
                            ),
                          )
                        : StoryViewIndicator(
                            currentIndex: currentIndex,
                            currentItemAnimatedValue: currentItemProgress,
                            totalItems: widget.items.length,
                            storyViewIndicatorConfig: storyViewIndicatorConfig,
                          ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: size.width * .2,
            height: size.height,
            child: GestureDetector(
              onTap: _playPrevious,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: size.width * .2,
            height: size.height,
            child: GestureDetector(
              onTap: _playNext,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: GestureDetector(
              key: ValueKey('$currentIndex'),
              onLongPressDown: (details) => _pauseMedia(),
              onLongPressUp: _resumeMedia,
              onLongPressEnd: (details) => _resumeMedia(),
              onLongPressCancel: _resumeMedia,
              onVerticalDragStart: widget.onSlideStart?.call,
              onVerticalDragUpdate: widget.onSlideDown?.call,
            ),
          ),
        ),
        if (widget.headerWidget != null) ...{
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
                bottom: storyViewIndicatorConfig.enableBottomSafeArea,
                top: storyViewIndicatorConfig.enableTopSafeArea,
                child: widget.headerWidget!),
          ),
        },
        if (widget.footerWidget != null) ...{
          Align(
            alignment: Alignment.bottomCenter,
            child: widget.footerWidget!,
          ),
        },
      ],
    );
  }
}
