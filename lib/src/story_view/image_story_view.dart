import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/story_item.dart';
import '../utils/story_utils.dart';

typedef OnImageLoaded = void Function(bool);

/// A widget that displays an image from various sources (asset, file, network) in a story view.
/// Notifies when the image is loaded via the [onImageLoaded] callback.
class ImageStoryView extends StatefulWidget {
  /// The story item containing image data and configuration.
  final StoryItem storyItem;

  /// Callback function to notify when the image is loaded.
  final OnImageLoaded? onImageLoaded;

  const ImageStoryView(
      {required this.storyItem, this.onImageLoaded, super.key});

  @override
  State<ImageStoryView> createState() => _ImageStoryViewState();
}

class _ImageStoryViewState extends State<ImageStoryView> {
  /// A flag to ensure the [widget.onImageLoaded] callback is called only once.
  bool _calledOnImageLoaded = false;

  /// Marks the image as loaded and calls the [widget.onImageLoaded] callback if it hasn't been called already.
  void markImageAsLoaded() {
    if (!_calledOnImageLoaded) {
      widget.onImageLoaded?.call(true);
      _calledOnImageLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageConfig = widget.storyItem.imageConfig;

    /// If the image source is an asset, use [AssetImage].
    if (widget.storyItem.storyItemSource.isAsset) {
      return Image(
        image: AssetImage(widget.storyItem.url!),
        height: imageConfig?.height,
        fit: imageConfig?.fit,
        width: imageConfig?.width,
        errorBuilder: (context, error, stackTrace) {
          // Display error widget if provided, otherwise show an empty widget.
          if (widget.storyItem.errorWidget != null) {
            return widget.storyItem.errorWidget!;
          }
          return const SizedBox.shrink();
        },
        loadingBuilder: (context, child, loadingProgress) {
          // Workaround for AssetImage loading issues.
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

    /// If the image source is a file, use [FileImage].
    else if (widget.storyItem.storyItemSource.isFile) {
      return Image(
        image: FileImage(File(widget.storyItem.url!)),
        height: imageConfig?.height,
        fit: imageConfig?.fit,
        width: imageConfig?.width,
        errorBuilder: (context, error, stackTrace) {
          // Display error widget if provided, otherwise show an empty widget.
          if (widget.storyItem.errorWidget != null) {
            return widget.storyItem.errorWidget!;
          }
          return const SizedBox.shrink();
        },
        loadingBuilder: (context, child, loadingProgress) {
          // Check if the image has loaded and call the callback if necessary.
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

    /// If the image source is a network URL, use [CachedNetworkImage].
    return CachedNetworkImage(
      imageUrl: widget.storyItem.url!,
      height: imageConfig?.height,
      fit: imageConfig?.fit,
      width: imageConfig?.width,
      imageBuilder: (context, imageProvider) {
        // Mark the image as loaded once it is built.
        markImageAsLoaded();
        return Image(
          image: imageProvider,
        );
      },
      errorWidget: (context, error, obj) {
        // Display error widget if provided, otherwise show an empty widget.
        if (widget.storyItem.errorWidget != null) {
          return widget.storyItem.errorWidget!;
        }
        return const SizedBox.shrink();
      },
      progressIndicatorBuilder: imageConfig?.progressIndicatorBuilder,
    );
  }
}
