import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterstoryview/flutterstoryview.dart';

typedef OnImageLoaded = void Function(bool);

// ignore: must_be_immutable
class ImageStoryView extends StatelessWidget {
  ImageStoryView({required this.storyItem, this.onImageLoaded, super.key});

  final StoryItem storyItem;
  final OnImageLoaded? onImageLoaded;

  bool _calledOnImageLoaded = false;

  void markImageAsLoaded() {
    if (!_calledOnImageLoaded) {
      onImageLoaded?.call(true);
      _calledOnImageLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageConfig = storyItem.imageConfig;
    if (storyItem.storyItemSource.isAsset) {
      return Image(
        image: AssetImage(storyItem.url),
        height: imageConfig?.height,
        fit: imageConfig?.fit,
        width: imageConfig?.width,
        errorBuilder: (context, error, stackTrace) {
          if (storyItem.errorWidget != null) {
            return storyItem.errorWidget!;
          }
          return const SizedBox.shrink();
        },
        loadingBuilder: (context, child, loadingProgress) {
          /// Loading Builder doesn't work properly with AssetImage
          /// Github Issue : https://github.com/flutter/flutter/issues/96700
          /// Temporary Workaround : https://stackoverflow.com/questions/70722667/image-loadingbuilder-does-not-work-with-asset-image
          if (((child as Semantics).child as RawImage).image != null) {
            markImageAsLoaded();
            return child;
          }
          final w = imageConfig?.progressIndicatorBuilder?.call(
              context,
              '',
              DownloadProgress('', loadingProgress?.expectedTotalBytes ?? 0,
                  loadingProgress?.cumulativeBytesLoaded ?? 0));
          return w ?? const SizedBox.shrink();
        },
      );
    } else if (storyItem.storyItemSource.isFile) {
      return Image(
        image: FileImage(File(storyItem.url)),
        height: imageConfig?.height,
        fit: imageConfig?.fit,
        width: imageConfig?.width,
        errorBuilder: (context, error, stackTrace) {
          if (storyItem.errorWidget != null) {
            return storyItem.errorWidget!;
          }
          return const SizedBox.shrink();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (((child as Semantics).child as RawImage).image != null) {
            markImageAsLoaded();
            return child;
          }
          final w = imageConfig?.progressIndicatorBuilder?.call(
              context,
              '',
              DownloadProgress('', loadingProgress?.expectedTotalBytes ?? 0,
                  loadingProgress?.cumulativeBytesLoaded ?? 0));
          return w ?? const SizedBox.shrink();
        },
      );
    }
    return CachedNetworkImage(
      imageUrl: storyItem.url,
      height: imageConfig?.height,
      fit: imageConfig?.fit,
      width: imageConfig?.width,
      imageBuilder: (context, imageProvider) {
        markImageAsLoaded();
        return Image(
          image: imageProvider,
        );
      },
      errorWidget: (context, error, obj) {
        if (storyItem.errorWidget != null) {
          return storyItem.errorWidget!;
        }
        return const SizedBox.shrink();
      },
      progressIndicatorBuilder: imageConfig?.progressIndicatorBuilder,
    );
  }
}
