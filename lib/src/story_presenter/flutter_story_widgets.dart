import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../controller/flutter_story_controller.dart';
import 'story_view_indicator.dart';
import '../models/story_view_indicator_config.dart';
import '../utils/story_utils.dart';
import 'story_view.dart'; // Import existing typedefs

/// Story presenter that accepts List<Widget> directly
class FlutterStoryPresenterWidgets extends StatefulWidget {
  const FlutterStoryPresenterWidgets({
    super.key,
    this.flutterStoryController,
    this.widgets = const [],
    this.onStoryChanged,
    this.onLeftTap,
    this.onRightTap,
    this.onCompleted,
    this.onPreviousCompleted,
    this.initialIndex = 0,
    this.storyViewIndicatorConfig,
    this.restartOnCompleted = true,
    this.headerWidget,
    this.footerWidget,
    this.onSlideDown,
    this.onSlideStart,
    this.defaultDuration = const Duration(seconds: 3),
  }) : assert(initialIndex < widgets.length);

  /// List of widgets to display as stories
  final List<Widget> widgets;

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

  /// Widget to display user profile or other details at the top of the screen.
  final Widget? headerWidget;

  /// Widget to display text field or other content at the bottom of the screen.
  final Widget? footerWidget;

  /// Default duration for each story widget
  final Duration defaultDuration;

  @override
  State<FlutterStoryPresenterWidgets> createState() => _FlutterStoryPresenterWidgetsState();
}

class _FlutterStoryPresenterWidgetsState extends State<FlutterStoryPresenterWidgets>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _currentProgressAnimation;
  int currentIndex = 0;
  bool isCurrentItemLoaded = false;
  double currentItemProgress = 0;
  VideoPlayerController? _currentVideoController;
  List<VideoPlayerController> _allVideoControllers = []; // Track all video controllers
  /// Whether the presenter is waiting for a video to load for the current item.
  /// When a video widget is present it will call the provided callback with
  /// `null` to indicate loading started and later with a non-null
  /// controller when ready. While true we avoid starting the default
  /// countdown so the indicator matches the video duration.
  bool _waitingForVideo = false;

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
    
    WidgetsBinding.instance.addObserver(this);

    super.initState();
      _startStoryView();
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
      ?..removeListener(_storyControllerListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Returns the current widget.
  Widget get currentWidget => widget.widgets[currentIndex];

  /// Callback to register video controller from child widgets
  void _onVideoLoad(VideoPlayerController? controller) {
    // If controller is null it means the child video widget signalled
    // that a video exists and is currently loading. We should wait until
    // the real controller arrives before starting the indicator.
    if (controller == null) {
      _waitingForVideo = true;
      _currentVideoController = null;
      // Stop any running countdown so the indicator doesn't advance
      // while the video is still loading.
      _animationController?.stop(canceled: false);
      _animationController?.reset();
      currentItemProgress = 0;
      if (mounted) setState(() {});
      return;
    }

    // Add to list of all controllers for managing multiple videos
    if (!_allVideoControllers.contains(controller)) {
      _allVideoControllers.add(controller);
      debugPrint('StoryPresenter: Added video controller. Total controllers: ${_allVideoControllers.length}');
    }

    // Use the first video controller for timing, but track all for control
    if (_currentVideoController == null) {
      debugPrint('StoryPresenter: Setting primary video controller');
      _currentVideoController = controller;
      
      // Set animation duration to video duration for proper indicator length
      _animationController?.duration = controller.value.duration;

      // Create a progress animation that maps controller ticks to 0..1 and
      // attach our listeners so the UI updates and completion is handled.
      _currentProgressAnimation =
          Tween<double>(begin: 0, end: 1).animate(_animationController!)
            ..addListener(animationListener)
            ..addStatusListener(animationStatusListener);

      // Reset and start the animation tied to the video's duration.
      _animationController?..reset();
      _animationController?.forward();
    }

    // Received actual video controller -> stop waiting and start animation
    _waitingForVideo = false;
  }

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
      } else if (storyStatus.isPause) {
        _pauseMedia();
      } else if (storyStatus.isPrevious) {
        _playPrevious();
      } else if (storyStatus.isNext) {
        _playNext();
      } else if (storyStatus.isMute) {
        // Mute all video controllers
        for (var controller in _allVideoControllers) {
          controller.setVolume(0);
        }
      } else if (storyStatus.isUnMute) {
        // Unmute all video controllers
        for (var controller in _allVideoControllers) {
          controller.setVolume(1);
        }
      }
    }

    if (jumpIndex != null &&
        jumpIndex >= 0 &&
        jumpIndex < widget.widgets.length) {
      currentIndex = jumpIndex - 1;
      _playNext();
    }
  }

  /// Starts the story view.
  void _startStoryView() {
    widget.onStoryChanged?.call(currentIndex);
    // Start media playback. For video items we want to wait until the
    // video widget notifies us that it exists and has loaded (see
    // _onVideoLoad which receives a null controller to indicate loading
    // has started and a non-null controller when ready).
    _waitingForVideo = false;
    _currentVideoController = null;
    _playMedia();

    // After the current frame, if no video signalled its presence we
    // assume the current item is not a video and start the countdown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_waitingForVideo && _currentVideoController == null) {
        // No video expected, start default countdown
        _startStoryCountdown();
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  /// Resets the animation controller and its listeners.
  void _resetAnimation() {
    // Remove listeners from the current animation first to avoid
    // receiving events from the old animation instance while we reset it.
    _currentProgressAnimation
      ?..removeListener(animationListener)
      ..removeStatusListener(animationStatusListener);

    // Reset the controller, but keep the controller instance so it can
    // be reused for subsequent countdowns or video-driven animations.
    _animationController?.reset();
    _currentProgressAnimation = null;
  }

  /// Initializes and starts the media playback for the current story widget.
  void _playMedia() {
    // Mark loaded state. If a video is expected, _onVideoLoad(null) will
    // set _waitingForVideo = true and we will start the animation only
    // when a non-null controller arrives. For non-video items the
    // post-frame callback in _startStoryView will start the countdown.
    isCurrentItemLoaded = true;
  }

  /// Resumes the media playback.
  void _resumeMedia() {
    // Resume all video controllers
    for (var controller in _allVideoControllers) {
      controller.play();
    }
    if (_currentProgressAnimation != null) {
      _animationController?.forward(
        from: _currentProgressAnimation?.value,
      );
    }
  }

  /// Starts the countdown for the story widget duration.
  void _startStoryCountdown() {
    _animationController ??= AnimationController(
      vsync: this,
    );

    _animationController?.duration = widget.defaultDuration;

    _currentProgressAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController!)
          ..addListener(animationListener)
          ..addStatusListener(animationStatusListener);

    _animationController!.forward();
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
    // Pause all video controllers
    for (var controller in _allVideoControllers) {
      controller.pause();
    }
    _animationController?.stop(canceled: false);
  }

  /// Plays the next story widget.
  void _playNext() async {
    if (currentIndex == widget.widgets.length - 1) {
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
    _currentVideoController = null; // Clear video controller when moving to next story
    _allVideoControllers.clear(); // Clear all video controllers
    _resetAnimation();
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    // Allow the child widget a frame to signal video presence. If no
    // video signals its presence by the end of this frame, start the
    // default countdown for non-video items. This prevents the
    // indicator from briefly progressing while a video is still
    // loading and only starting at the real video duration once ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_waitingForVideo && _currentVideoController == null) {
        _startStoryCountdown();
        if (mounted) setState(() {});
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  /// Plays the previous story widget.
  void _playPrevious() {
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
    _currentVideoController = null; // Clear video controller when moving to previous story
    _allVideoControllers.clear(); // Clear all video controllers
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
    // As with _playNext, give the child one frame to report video
    // loading. If none reports, start the default countdown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_waitingForVideo && _currentVideoController == null) {
        _startStoryCountdown();
        if (mounted) setState(() {});
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StoryVideoCallbackProvider(
      onVideoLoad: _onVideoLoad,
      child: Stack(
      children: [
        Positioned.fill(
          child: currentWidget,
        ),
        Align(
          alignment: storyViewIndicatorConfig.alignment,
          child: Padding(
            padding: storyViewIndicatorConfig.margin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _animationController != null
                    ? AnimatedBuilder(
                        animation: _animationController!,
                        builder: (context, child) => StoryViewIndicator(
                          currentIndex: currentIndex,
                          currentItemAnimatedValue: currentItemProgress,
                          totalItems: widget.widgets.length,
                          storyViewIndicatorConfig: storyViewIndicatorConfig,
                        ),
                      )
                    : StoryViewIndicator(
                        currentIndex: currentIndex,
                        currentItemAnimatedValue: currentItemProgress,
                        totalItems: widget.widgets.length,
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
              onTap: () async {
                if (widget.onLeftTap != null) {
                  final shouldPlayPrevious = await widget.onLeftTap!();
                  if (shouldPlayPrevious) {
                    _playPrevious();
                  }
                } else {
                  _playPrevious();
                }
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: size.width * .2,
            height: size.height,
            child: GestureDetector(
              onTap: () async {
                if (widget.onRightTap != null) {
                  final shouldPlayNext = await widget.onRightTap!();
                  if (shouldPlayNext) {
                    _playNext();
                  }
                } else {
                  _playNext();
                }
              },
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
    ),
    );
  }
}

/// InheritedWidget to provide video load callback to child widgets
class StoryVideoCallbackProvider extends InheritedWidget {
  final OnVideoLoad? onVideoLoad;

  const StoryVideoCallbackProvider({
    required this.onVideoLoad,
    required super.child,
  });

  static StoryVideoCallbackProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoryVideoCallbackProvider>();
  }

  @override
  bool updateShouldNotify(StoryVideoCallbackProvider oldWidget) {
    return onVideoLoad != oldWidget.onVideoLoad;
  }
}


