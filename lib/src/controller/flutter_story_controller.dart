import 'package:flutter/material.dart';

import '../utils/story_utils.dart';

/// A controller to manage the state and actions of a story view
class FlutterStoryController extends ChangeNotifier {
  /// The current action status of the story. Defaults to playing.
  StoryAction storyStatus = StoryAction.play;

  /// The index to which the story should jump. Null if no jump is required.
  int? jumpIndex;

  /// Sets the story status to play and notifies listeners of the change.
  void play() {
    storyStatus = StoryAction.play;
    notifyListeners();
  }

  void playCustomWidget() {
    storyStatus = StoryAction.playCustomWidget;
    notifyListeners();
  }

  /// Sets the story status to pause and notifies listeners of the change.
  void pause() {
    storyStatus = StoryAction.pause;
    notifyListeners();
  }

  /// Sets the story status to next (move to the next story) and notifies listeners of the change.
  void next() {
    storyStatus = StoryAction.next;
    notifyListeners();
  }

  /// Sets the story status to mute (mute audio) and notifies listeners of the change.
  void mute() {
    storyStatus = StoryAction.mute;
    notifyListeners();
  }

  /// Sets the story status to unMute (un-mute audio) and notifies listeners of the change.
  void unMute() {
    storyStatus = StoryAction.unMute;
    notifyListeners();
  }

  /// Sets the story status to previous (move to the previous story) and notifies listeners of the change.
  void previous() {
    storyStatus = StoryAction.previous;
    notifyListeners();
  }

  /// Sets the index of the story to jump to and notifies listeners of the change.
  ///
  /// [index] The index to which the story should jump.
  void jumpTo(int index) {
    jumpIndex = index;
    notifyListeners();
  }
}
