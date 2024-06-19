import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

class StoryItem {
  const StoryItem({
    this.url,
    required this.storyItemType,
    this.thumbnail,
    this.isMuteByDefault = false,
    this.duration = const Duration(seconds: 3),
    this.storyItemSource = StoryItemSource.network,
    this.videoConfig,
    this.errorWidget,
    this.imageConfig,
    this.textConfig,
    this.webConfig,
    this.customWidget,
  })  : assert(
          storyItemType == StoryItemType.custom || url != null,
          'URL is required when storyItemType is not custom',
        ),
        assert(
          storyItemType != StoryItemType.custom || customWidget != null,
          'CustomWidget is required when storyItemType is custom',
        );

  /// Duration of displaying the widget
  final Duration duration;

  /// Widget to display beneath main view as thumbnail
  final Widget? thumbnail;

  /// Widget to display when error occurs loading View
  final Widget? errorWidget;

  /// Custom Widget to display fully instead of any other view
  final Widget? Function(FlutterStoryController?)? customWidget;

  final StoryItemType storyItemType;

  /// Asset URL, File Path or Web URL
  final String? url;

  /// Applicable when [storyItemType] is [StoryItemType.video]
  final bool isMuteByDefault;

  /// Defaults to [StoryItemSource.network]
  final StoryItemSource storyItemSource;

  /// Applicable when [storyItemType] is [StoryItemType.image]
  final StoryViewImageConfig? imageConfig;

  /// Applicable when [storyItemType] is [StoryItemType.video]
  final StoryViewVideoConfig? videoConfig;

  /// Applicable when [storyItemType] is [StoryItemType.text]
  final StoryViewTextConfig? textConfig;

  /// Applicable when [storyItemType] is [StoryItemType.web]
  final StoryViewWebConfig? webConfig;
}

class StoryCustomWidgetWrapper extends StatelessWidget {
  const StoryCustomWidgetWrapper({
    super.key,
    required this.child,
    this.isAutoStart = true,
    this.onLoaded,
  });

  final Widget? child;
  final bool isAutoStart;
  final Function()? onLoaded;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        onLoaded?.call();
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
