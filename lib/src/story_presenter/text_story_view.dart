import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:just_audio/just_audio.dart';

typedef OnTextStoryLoaded = void Function(bool);

class TextStoryView extends StatefulWidget {
  const TextStoryView(
      {required this.storyItem,
      this.onTextStoryLoaded,
      this.onAudioLoaded,
      super.key});

  final StoryItem storyItem;
  final OnTextStoryLoaded? onTextStoryLoaded;
  final OnAudioLoaded? onAudioLoaded;

  @override
  State<TextStoryView> createState() => _TextStoryViewState();
}

class _TextStoryViewState extends State<TextStoryView> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    if (widget.storyItem.audioConfig == null) {
      widget.onTextStoryLoaded?.call(true);
    }
    audioInit();
    super.initState();
  }

  Future<void> audioInit() async {
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
  }

  @override
  void dispose() {
    audioPlayer.pause();
    audioPlayer.dispose();
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
