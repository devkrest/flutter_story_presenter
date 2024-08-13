import 'package:just_audio/just_audio.dart';
import '../utils/story_utils.dart';

typedef OnAudioStart = Function(AudioPlayer);

/// [StoryViewAudioConfig] is a configuration class that holds data needed for playing audio in a story view.
class StoryViewAudioConfig {
  const StoryViewAudioConfig({
    required this.audioPath,
    required this.source,
    required this.onAudioStart,
  });

  // The path or URL of the audio file to be played.
  final String audioPath;

  // The source of the story item, which could help in identifying where the audio is coming from.
  final StoryItemSource source;

  // A callback function that is called when the audio starts playing.
  final OnAudioStart onAudioStart;
}
