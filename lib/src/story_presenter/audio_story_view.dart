import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/src/utils/audio_player.dart';
import 'package:video_player/video_player.dart';
import '../models/story_item.dart';
import '../story_presenter/story_view.dart';
import '../utils/story_utils.dart';
import '../utils/video_utils.dart';

/// A widget that displays a video story view, supporting different video sources
/// (network, file, asset) and optional thumbnail and error widgets.
class AudioStoryView extends StatefulWidget {
  /// The story item containing video data and configuration.
  final StoryItem storyItem;

  /// Callback function to notify when the video is loaded.
  final OnAudioLoaded? onAudioLoaded;

  /// In case of single video story
  final bool? looping;

  /// Creates a [AudioStoryView] widget.
  const AudioStoryView(
      {required this.storyItem, this.onAudioLoaded, this.looping, super.key});

  @override
  State<AudioStoryView> createState() => _AudioStoryViewState();
}

class _AudioStoryViewState extends State<AudioStoryView> {
  bool hasError = false;

  @override
  void initState() {
    initAudio();
    super.initState();
  }

  Future<void> initAudio() async {
    if (widget.storyItem.storyItemSource.isNetwork) {
      audioPlayer.setUrl(widget.storyItem.url!);
    } else if (widget.storyItem.storyItemSource.isFile) {
      audioPlayer.setFilePath(widget.storyItem.url!);
    } else if (widget.storyItem.storyItemSource.isFile) {
      audioPlayer.setAsset(widget.storyItem.url!);
    }
    audioPlayer.play();
    widget.onAudioLoaded?.call(audioPlayer);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyItem = widget.storyItem;
    return Container(
      color: storyItem.textConfig?.backgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (storyItem.textConfig?.backgroundWidget != null) ...{
            storyItem.textConfig!.backgroundWidget!,
          },
          if (storyItem.textConfig?.textWidget != null) ...{
            storyItem.textConfig!.textWidget!,
          } else ...{
            Align(
              alignment: widget.storyItem.textConfig?.textAlignment ??
                  Alignment.center,
              child: Text(
                widget.storyItem.url!,
              ),
            ),
          }
        ],
      ),
    );
  }
}
