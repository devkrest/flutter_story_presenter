import 'package:flutter/material.dart';
import 'package:flutterstoryview/flutterstoryview.dart';
import 'package:flutterstoryview/src/story_view/story_view_indicator.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

typedef OnStoryChanged = void Function(int);
typedef OnCompleted = void Function();
typedef OnLeftTap = void Function();
typedef OnRightTap = void Function();
typedef OnTopTap = void Function();
typedef OnBottomTap = void Function();
typedef OnItemBuild = Widget? Function(int, Widget);
typedef OnVideoLoad = void Function(VideoPlayerController?);

class FlutterStoryView extends StatefulWidget {
  const FlutterStoryView(
      {this.flutterStoryViewController,
      this.items = const [],
      this.onStoryChanged,
      this.onBottomTap,
      this.onLeftTap,
      this.onRightTap,
      this.onTopTap,
      this.itemBuilder,
      this.onCompleted,
      this.initialIndex = 0,
      this.storyViewIndicatorConfig,
      this.restartOnCompleted = true,
      this.onVideoLoad,
      super.key})
      : assert(initialIndex < items.length - 1);

  final List<StoryItem> items;

  final FlutterStoryViewController? flutterStoryViewController;

  final OnStoryChanged? onStoryChanged;
  final OnCompleted? onCompleted;
  final OnLeftTap? onLeftTap;
  final OnRightTap? onRightTap;
  final OnTopTap? onTopTap;
  final OnBottomTap? onBottomTap;
  final OnItemBuild? itemBuilder;
  final bool restartOnCompleted;
  final int initialIndex;
  final StoryViewIndicatorConfig? storyViewIndicatorConfig;
  final OnVideoLoad? onVideoLoad;

  @override
  State<FlutterStoryView> createState() => _FlutterStoryViewState();
}

class _FlutterStoryViewState extends State<FlutterStoryView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController? _animationController;
  late Animation? _currentProgressAnimation;
  int currentIndex = 0;
  bool isCurrentItemLoaded = false;
  double currentItemProgress = 0;
  VideoPlayerController? _currentVideoPlayer;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
    );
    currentIndex = widget.initialIndex;
    widget.flutterStoryViewController?.addListener(_storyControllerListener);
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
    widget.flutterStoryViewController
      ?..removeListener(_storyControllerListener)
      ..dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  StoryItem get currentItem => widget.items[currentIndex];

  StoryViewIndicatorConfig get storyViewIndicatorConfig =>
      widget.storyViewIndicatorConfig ?? const StoryViewIndicatorConfig();

  void _storyControllerListener() {
    final controller = widget.flutterStoryViewController;
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
      }
    }
    if (jumpIndex != null &&
        jumpIndex >= 0 &&
        jumpIndex < widget.items.length) {
      currentIndex = jumpIndex - 1;
      _playNext();
    }
  }

  void _startStoryView() {
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    setState(() {});
  }

  void _resetAnimation() {
    _animationController?.reset();
    _animationController
      ?..removeListener(animationListener)
      ..removeStatusListener(animationStatusListener);
  }

  void _playMedia() {
    isCurrentItemLoaded = false;
  }

  void _resumeMedia() {
    _currentVideoPlayer?.play();
    _animationController?.forward(
      from: _currentProgressAnimation?.value,
    );
  }

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
      _animationController?.forward(from: _currentProgressAnimation?.value);
    }
  }

  void animationListener() {
    currentItemProgress = _animationController?.value ?? 0;
  }

  void animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _playNext();
    }
  }

  void _pauseMedia() {
    _currentVideoPlayer?.pause();
    _animationController?.stop(canceled: false);
  }

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

  void _playNext() {
    if (_currentVideoPlayer != null) {
      _currentVideoPlayer?.dispose();
      _currentVideoPlayer = null;
      _currentVideoPlayer?.removeListener(videoListener);
    }
    if (currentIndex == widget.items.length - 1) {
      widget.onCompleted?.call();
      if (widget.restartOnCompleted) {
        currentIndex = 0;
        _resetAnimation();
        _startStoryView();
      }
      return;
    }
    currentIndex = currentIndex + 1;
    _resetAnimation();
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    setState(() {});
  }

  void _playPrevious() {
    if (_currentVideoPlayer != null) {
      _currentVideoPlayer?.removeListener(videoListener);
      _currentVideoPlayer?.dispose();
      _currentVideoPlayer = null;
    }
    if (currentIndex == 0) {
      _resetAnimation();
      _startStoryCountdown();
      setState(() {});
      return;
    }
    _resetAnimation();
    currentIndex = currentIndex - 1;
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        if (currentItem.thumbnail != null) ...{
          currentItem.thumbnail!,
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
              onVideoLoad: (videoPlayer) {
                isCurrentItemLoaded = true;
                _currentVideoPlayer?.dispose();
                _currentVideoPlayer = videoPlayer;
                widget.onVideoLoad?.call(videoPlayer);
                _startStoryCountdown();
                setState(() {});
              },
            ),
          ),
        },
        Align(
          alignment: storyViewIndicatorConfig.alignment,
          child: Padding(
            padding: storyViewIndicatorConfig.margin,
            child: _currentVideoPlayer != null
                ? SmoothVideoProgress(
                    controller: _currentVideoPlayer!,
                    builder: (context, progress, duration, child) {
                      return StoryViewIndicator(
                        currentIndex: currentIndex,
                        currentItemAnimatedValue:
                            progress.inMilliseconds / duration.inMilliseconds,
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
                          storyViewIndicatorConfig: storyViewIndicatorConfig,
                        ),
                      )
                    : StoryViewIndicator(
                        currentIndex: currentIndex,
                        currentItemAnimatedValue: currentItemProgress,
                        totalItems: widget.items.length,
                        storyViewIndicatorConfig: storyViewIndicatorConfig,
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
              onLongPressDown: (details) => _pauseMedia(),
              onLongPressUp: _resumeMedia,
              onLongPressEnd: (details) => _resumeMedia(),
              onLongPressCancel: _resumeMedia,
            ),
          ),
        ),
      ],
    );
  }
}
