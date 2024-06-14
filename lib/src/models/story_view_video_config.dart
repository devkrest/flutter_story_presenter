import 'package:flutter/material.dart';
import 'package:flutterstoryview/src/utils/story_utils.dart';
import 'package:video_player/video_player.dart';

class StoryViewVideoConfig {
  const StoryViewVideoConfig({
    this.fit,
    this.height,
    this.width,
    this.loadingWidget,
    this.cacheVideo = false,
    this.useVideoAspectRatio = true,
    this.videoPlayerOptions,
  });

  /// Height for the Video
  final double? height;

  /// Width for the Video
  final double? width;

  /// BoxFit settings for the Video
  final BoxFit? fit;

  /// If to use Video Aspect ratio
  final bool useVideoAspectRatio;

  /// If to cache Video for directly playing from file
  /// Applicable when [StoryItemSource] is [StoryItemSource.network]
  final bool cacheVideo;

  /// Progress Indicator for building Video
  final Widget? loadingWidget;

  /// In case of mixing the audio with music playing on device
  final VideoPlayerOptions? videoPlayerOptions;
}
