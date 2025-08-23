import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class VideoUtils {
  VideoUtils._();

  // Cache manager to handle caching of video files.
  final _cacheManager = DefaultCacheManager();

  // Singleton instance of VideoUtils.
  static final VideoUtils instance = VideoUtils._();

  // Method to create a VideoPlayerController from a URL.
  // If cacheFile is true, it attempts to cache the video file.
  Future<VideoPlayerController> videoControllerFromUrl({
    required String url,
    bool? cacheFile = false,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String>? httpHeaders,
  }) async {
    try {
      File? cachedVideo;
      // If caching is enabled, try to get the cached file.
      if (cacheFile ?? false) {
        cachedVideo =
            await _cacheManager.getSingleFile(url, headers: httpHeaders ?? {});
      }
      // If a cached video file is found, create a VideoPlayerController from it.
      if (cachedVideo != null) {
        return VideoPlayerController.file(
          cachedVideo,
          videoPlayerOptions: videoPlayerOptions,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    // If no cached file is found, create a VideoPlayerController from the network URL.
    return VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: httpHeaders ?? {},
      videoPlayerOptions: videoPlayerOptions,
    );
  }

  // Method to create a VideoPlayerController from a local file.
  VideoPlayerController videoControllerFromFile({
    required File file,
    VideoPlayerOptions? videoPlayerOptions,
  }) {
    return VideoPlayerController.file(
      file,
      videoPlayerOptions: videoPlayerOptions,
    );
  }

  // Method to create a VideoPlayerController from an asset file.
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
