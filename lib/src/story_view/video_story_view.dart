import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterstoryview/flutterstoryview.dart';
import 'package:flutterstoryview/src/utils/video_utils.dart';
import 'package:video_player/video_player.dart';

class VideoStoryView extends StatefulWidget {
  const VideoStoryView({required this.storyItem, this.onVideoLoad, super.key});

  final StoryItem storyItem;
  final OnVideoLoad? onVideoLoad;

  @override
  State<VideoStoryView> createState() => _VideoStoryViewState();
}

class _VideoStoryViewState extends State<VideoStoryView> {
  VideoPlayerController? videoPlayerController;
  bool hasError = false;

  @override
  void initState() {
    _initialiseVideoPlayer();
    super.initState();
  }

  Future<void> _initialiseVideoPlayer() async {
    try {
      final storyItem = widget.storyItem;
      if (storyItem.storyItemSource.isNetwork) {
        videoPlayerController =
            await VideoUtils.instance.videoControllerFromUrl(
          url: storyItem.url,
          cacheFile: storyItem.videoConfig?.cacheVideo,
          videoPlayerOptions: storyItem.videoConfig?.videoPlayerOptions,
        );
      } else if (storyItem.storyItemSource.isFile) {
        videoPlayerController = VideoUtils.instance.videoControllerFromFile(
          file: File(storyItem.url),
          videoPlayerOptions: storyItem.videoConfig?.videoPlayerOptions,
        );
      } else {
        videoPlayerController = VideoUtils.instance.videoControllerFromAsset(
          assetPath: storyItem.url,
          videoPlayerOptions: storyItem.videoConfig?.videoPlayerOptions,
        );
      }
      await videoPlayerController?.initialize();
      widget.onVideoLoad?.call(videoPlayerController!);
      await videoPlayerController?.play();
      await videoPlayerController?.setVolume(storyItem.isMuteByDefault ? 0 : 1);
    } catch (e) {
      hasError = true;
      debugPrint('$e');
    }
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.storyItem.thumbnail != null) ...{
          widget.storyItem.thumbnail!,
        },
        if (widget.storyItem.errorWidget != null && hasError) ...{
          widget.storyItem.errorWidget!,
        },
        if (videoPlayerController != null) ...{
          if (widget.storyItem.videoConfig?.useVideoAspectRatio ?? false) ...{
            AspectRatio(
              aspectRatio: videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(videoPlayerController!),
            )
          } else ...{
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoPlayerController!.value.size.width,
                  height: videoPlayerController!.value.size.height,
                  child: VideoPlayer(videoPlayerController!),
                ),
              ),
            )
          },
        }
      ],
    );
  }
}
