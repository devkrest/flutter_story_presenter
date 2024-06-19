import '../controller/flutter_story_controller.dart';

/// To Perform Action on Story with [FlutterStoryController]
enum StoryAction { play, pause, next, previous, mute, unMute, playCustomWidget }

/// Story Item Type to Display
enum StoryItemType { image, video, text, web, custom }

/// Story Item Source to Display Widgets from Asset/Network
enum StoryItemSource { asset, network, file }

extension StoryActionExtensions on StoryAction {
  bool get isPlay => this == StoryAction.play;

  bool get isPause => this == StoryAction.pause;

  bool get isNext => this == StoryAction.next;

  bool get isPrevious => this == StoryAction.previous;

  bool get isMute => this == StoryAction.mute;

  bool get isUnMute => this == StoryAction.unMute;

  bool get isPlayCustomWidget => this == StoryAction.playCustomWidget;
}

extension StoryItemTypeExtensions on StoryItemType {
  bool get isImage => this == StoryItemType.image;

  bool get isVideo => this == StoryItemType.video;

  bool get isText => this == StoryItemType.text;

  bool get isWeb => this == StoryItemType.web;

  bool get isCustom => this == StoryItemType.custom;
}

extension StorySourceTypeExtensions on StoryItemSource {
  bool get isNetwork => this == StoryItemSource.network;

  bool get isAsset => this == StoryItemSource.asset;

  bool get isFile => this == StoryItemSource.file;
}
