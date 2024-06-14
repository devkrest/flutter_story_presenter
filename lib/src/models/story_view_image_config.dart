import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryViewImageConfig {
  const StoryViewImageConfig({
    this.fit,
    this.height,
    this.width,
    this.progressIndicatorBuilder,
  });

  /// Height for the ImageBuilder
  final double? height;

  /// Width for the ImageBuilder
  final double? width;

  /// BoxFit settings for the ImageBuilder
  final BoxFit? fit;

  /// Progress Indicator for building image
  final Widget Function(BuildContext, String, DownloadProgress)?
      progressIndicatorBuilder;
}
