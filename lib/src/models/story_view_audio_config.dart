import 'package:flutter/material.dart';
import '../utils/story_utils.dart';
import 'package:video_player/video_player.dart';

class StoryViewAudioConfig {
  const StoryViewAudioConfig({
    this.loadingWidget,
  });

  /// Progress Indicator for building Video
  final Widget? loadingWidget;
}
