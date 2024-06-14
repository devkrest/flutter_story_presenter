import 'package:flutter/material.dart';
import 'package:flutterstoryview/src/story_view/story_view_indicator.dart';

class StoryViewIndicatorConfig {
  const StoryViewIndicatorConfig({
    this.activeColor = Colors.blue,
    this.backgroundCompletedColor = Colors.white,
    this.backgroundDisabledColor = Colors.grey,
    this.borderRadius = 4,
    this.height = 3.5,
    this.horizontalGap = 4,
    this.margin = const EdgeInsets.symmetric(
      horizontal: 4,
      vertical: 14,
    ),
    this.alignment = Alignment.topCenter,
    this.enableBottomSafeArea = true,
    this.enableTopSafeArea = true,
  });

  /// Spacing between two bars for [StoryViewIndicator]
  final double horizontalGap;

  /// Disabled Color when the bar is yet to be visited
  final Color backgroundDisabledColor;

  /// Active Value Color For the Current Bar
  final Color activeColor;

  /// Background Color for the Visited/Already Completed Bar
  final Color backgroundCompletedColor;

  /// Height or thickness for the Bar
  final double height;

  /// BorderRadius for the bar
  final double borderRadius;

  /// Placement or Alignment for the bar
  final Alignment alignment;

  /// Margin for the bar
  final EdgeInsets margin;

  /// Use SafeArea for Top
  final bool enableTopSafeArea;

  /// Use SafeArea for Bottom
  final bool enableBottomSafeArea;
}
