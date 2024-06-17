import 'package:flutter/material.dart';
import '../models/story_item.dart';
typedef OnTextStoryLoaded = void Function(bool);

class TextStoryView extends StatefulWidget {
  const TextStoryView(
      {required this.storyItem, this.onTextStoryLoaded, super.key});
  final StoryItem storyItem;
  final OnTextStoryLoaded? onTextStoryLoaded;

  @override
  State<TextStoryView> createState() => _TextStoryViewState();
}

class _TextStoryViewState extends State<TextStoryView> {
  @override
  void initState() {
    widget.onTextStoryLoaded?.call(true);
    super.initState();
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
