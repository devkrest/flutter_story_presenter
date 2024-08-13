import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:just_audio/just_audio.dart';

class StoryCustomWidgetWrapper extends StatefulWidget {
  const StoryCustomWidgetWrapper(
      {super.key,
      required this.builder,
      this.isAutoStart = true,
      this.onLoaded,
      this.onAudioLoaded,
      required this.storyItem});

  final CustomViewBuilder builder;

  /// The story item containing image data and configuration.
  final StoryItem storyItem;

  /// Callback function to notify when the audio is loaded.
  final OnAudioLoaded? onAudioLoaded;

  final bool isAutoStart;
  final Function()? onLoaded;

  @override
  State<StoryCustomWidgetWrapper> createState() =>
      _StoryCustomWidgetWrapperState();
}

class _StoryCustomWidgetWrapperState extends State<StoryCustomWidgetWrapper> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    if (widget.storyItem.audioConfig == null) {
      widget.onLoaded?.call();
      return;
    }

    audioInit();
    super.initState();
  }

  Future<void> audioInit() async {
    try {
      if (widget.storyItem.audioConfig != null) {
        switch (widget.storyItem.audioConfig!.source) {
          case StoryItemSource.asset:
            audioPlayer.setAsset(widget.storyItem.audioConfig!.audioPath);
            break;
          case StoryItemSource.network:
            audioPlayer.setUrl(widget.storyItem.audioConfig!.audioPath);
            break;
          case StoryItemSource.file:
            audioPlayer.setFilePath(widget.storyItem.audioConfig!.audioPath);
            break;
        }
        await audioPlayer.play();
        widget.onAudioLoaded?.call(audioPlayer);
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  void dispose() {
    audioPlayer.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return widget.builder(audioPlayer);
      },
    );
  }
}
