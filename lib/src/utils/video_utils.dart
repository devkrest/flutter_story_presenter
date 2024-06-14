import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class VideoUtils {
  VideoUtils._();

  final _cacheManager = DefaultCacheManager();

  static final VideoUtils instance = VideoUtils._();

  Future<VideoPlayerController> videoControllerFromUrl({
    required String url,
    bool? cacheFile = false,
    VideoPlayerOptions? videoPlayerOptions,
  }) async {
    try {
      File? cachedVideo;
      if (cacheFile ?? false) {
        cachedVideo = await _cacheManager.getSingleFile(url);
      }
      if (cachedVideo != null) {
        return VideoPlayerController.file(
          cachedVideo,
          videoPlayerOptions: videoPlayerOptions,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: videoPlayerOptions,
    );
  }

  VideoPlayerController videoControllerFromFile({
    required File file,
    VideoPlayerOptions? videoPlayerOptions,
  }) {
    return VideoPlayerController.file(
      file,
      videoPlayerOptions: videoPlayerOptions,
    );
  }

  VideoPlayerController videoControllerFromAsset({
    required String assetPath,
    VideoPlayerOptions? videoPlayerOptions,
  }) {
    return VideoPlayerController.asset(
      assetPath,
      videoPlayerOptions: videoPlayerOptions,
    );
  }
}
