import 'package:flutter/material.dart';
import 'package:flutterstoryview/src/utils/story_utils.dart';

class FlutterStoryViewController extends ChangeNotifier {
  StoryAction storyStatus = StoryAction.play;
  int jumpIndex = 0;

  void play() {
    storyStatus = StoryAction.play;
    notifyListeners();
  }

  void pause() {
    storyStatus = StoryAction.pause;
    notifyListeners();
  }

  void next() {
    storyStatus = StoryAction.next;
    notifyListeners();
  }

  void mute() {
    storyStatus = StoryAction.mute;
    notifyListeners();
  }

  void unMute() {
    storyStatus = StoryAction.unMute;
    notifyListeners();
  }

  void previous() {
    storyStatus = StoryAction.previous;
    notifyListeners();
  }

  void jumpTo(int index) {
    jumpIndex = index;
    notifyListeners();
  }
}
