import 'package:flutterstoryview/src/controller/flutter_story_view_controller.dart';

/// To Perform Action on Story with [FlutterStoryViewController]
enum StoryAction { play, pause, next, previous, mute, unMute }

/// Story Item Type to Display
enum StoryItemType { image, video, text, web }

/// Story Item Source to Display Widgets from Asset/Network
enum StoryItemSource { asset, network, file }

extension StoryActionExtensions on StoryAction {
  bool get isPlay => this == StoryAction.play;
  bool get isPause => this == StoryAction.pause;
  bool get isNext => this == StoryAction.next;
  bool get isPrevious => this == StoryAction.previous;
  bool get isMute => this == StoryAction.mute;
  bool get isUnMute => this == StoryAction.unMute;
}

extension StoryItemTypeExtensions on StoryItemType {
  bool get isImage => this == StoryItemType.image;
  bool get isVideo => this == StoryItemType.video;
  bool get isText => this == StoryItemType.text;
  bool get isWeb => this == StoryItemType.web;
}

extension StorySourceTypeExtensions on StoryItemSource {
  bool get isNetwork => this == StoryItemSource.network;
  bool get isAsset => this == StoryItemSource.asset;
  bool get isFile => this == StoryItemSource.file;
}
