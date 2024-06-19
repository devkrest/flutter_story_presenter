import 'package:flutter/material.dart';
import '../models/story_view_indicator_config.dart';

class StoryViewIndicator extends StatelessWidget {
  const StoryViewIndicator({
    required this.currentIndex,
    required this.totalItems,
    required this.currentItemAnimatedValue,
    required this.storyViewIndicatorConfig,
    super.key,
  });

  /// Describes the current Animated Value for the Bar Animation
  final double currentItemAnimatedValue;

  /// Total Bars to build
  final int totalItems;

  /// Current Active Index
  final int currentIndex;

  /// Configuration for the StoryView Indicator
  final StoryViewIndicatorConfig storyViewIndicatorConfig;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: storyViewIndicatorConfig.enableBottomSafeArea,
      top: storyViewIndicatorConfig.enableTopSafeArea,
      child: Row(
        children: [
          for (var i = 0; i < totalItems; i++) ...{
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: storyViewIndicatorConfig.horizontalGap,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(storyViewIndicatorConfig.borderRadius)),
                  child: LinearProgressIndicator(
                    minHeight: storyViewIndicatorConfig.height,
                    value: i == currentIndex ? currentItemAnimatedValue : 0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        storyViewIndicatorConfig.activeColor),
                    backgroundColor: i < currentIndex
                        ? storyViewIndicatorConfig.backgroundCompletedColor
                        : storyViewIndicatorConfig.backgroundDisabledColor,
                  ),
                ),
              ),
            ),
          },
        ],
      ),
    );
  }
}
