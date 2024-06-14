import 'package:flutter/material.dart';
import 'package:flutterstoryview/src/models/story_view_image_config.dart';
import 'package:flutterstoryview/src/models/story_view_video_config.dart';
import 'package:flutterstoryview/src/utils/story_utils.dart';

class StoryItem {
  const StoryItem({
    required this.url,
    required this.storyItemType,
    this.thumbnail,
    this.isMuteByDefault = false,
    this.duration = const Duration(seconds: 3),
    this.storyItemSource = StoryItemSource.network,
    this.videoConfig,
    this.errorWidget,
    this.imageConfig,
  });

  /// Duration of displaying the widget
  final Duration duration;

  /// Widget to display beneath main view as thumbnail
  final Widget? thumbnail;

  /// Widget to display when error occurs loading View
  final Widget? errorWidget;

  final StoryItemType storyItemType;

  /// Asset URL or Web URL
  final String url;

  /// Applicable when [storyItemType] is [StoryItemType.video]
  final bool isMuteByDefault;

  /// Defaults to [StoryItemSource.network]
  final StoryItemSource storyItemSource;

  /// Applicable when [storyItemType] is [StoryItemType.image]
  final StoryViewImageConfig? imageConfig;

  /// Applicable when [storyItemType] is [StoryItemType.video]
  final StoryViewVideoConfig? videoConfig;
}
