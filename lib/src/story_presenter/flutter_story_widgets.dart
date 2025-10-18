import 'dart:async';

import 'package:flutter/material.dart';
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
      ?..removeListener(_storyControllerListener)
      ..dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Returns the current widget.
  Widget get currentWidget => widget.widgets[currentIndex];

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
    _playMedia();
    if (mounted) {
      setState(() {});
    }
  }

  /// Resets the animation controller and its listeners.
  void _resetAnimation() {
    _animationController?.reset();
    _animationController?.forward();
    _animationController
      ?..removeListener(animationListener)
      ..removeStatusListener(animationStatusListener);
  }

  /// Initializes and starts the media playback for the current story widget.
  void _playMedia() {
    isCurrentItemLoaded = true;
    _startStoryCountdown();
  }

  /// Resumes the media playback.
  void _resumeMedia() {
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
    _resetAnimation();
    widget.onStoryChanged?.call(currentIndex);
    _playMedia();
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
    );
  }
}


