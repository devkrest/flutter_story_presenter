# FlutterStoryView

![FlutterStoryView](https://devkrest.com/github/flutter_story_view.png)

This Flutter package makes it easy to create story and news views like popular social media apps with just a few lines of code! 📱✨ It's loaded with features for customizing and managing stories, perfect for showcasing stories inside your awesome app.

## 🤌🏻 Features

🔹 **Supported Media Types**: Images, Videos, Text, Web & Custom

🔹 **Custom Loader & Thumbnails**: Add your custom thumbnails or loaders while loading the story 

🔹 **Option to Cache**: Image, Video, and show Loading Widgets

🔹 **Accurate Animated Progress Bar**

🔹 **Color Customization**: For Progress Bars

🔹 **Header & Footer Widgets** : For adding Profiles & Read more or Textfields

🔹 **Controls**: Pause, Resume, Next, Previous, Jump to, Mute, Unmute

🔹 **Gestures**: Tap, Right Tap, Left Tap, Slide or Drag Down

🔹 **Customizable Widget**: Display your own widgets as Story

🔹 **Callbacks**: Receive different callbacks based on the type of story item for handling state management.

## ⚙️ Installation
Add `flutterstoryview` to your `pubspec.yaml` dependencies. And Import it as 
```dart
import 'package:flutterstoryview/flutterstoryview.dart';
```

## 🔭 Guide to use
For a detailed view and more examples, check out `example/main.dart`.

Use `FlutterStoryView` to display stories on any screen. It accepts a list of `StoryItem`, each containing URLs for displaying images, videos, and web pages.

```dart
FlutterStoryView(
    controller : FlutterStoryViewController(),
    items: [
        /// For Image Story Item
        StoryItem(
            url:'https://picsum.photos/1000/1000',
            type: StoryItemType.image,
        ),
        /// For Video Story Item
        StoryItem(
            url:'https://videos.pexels.com/video-files/7297870/7297870-hd_1080_1920_30fps.mp4',
            type: StoryItemType.video,
        ),
        /// For Text Story Item
        StoryItem(
            url:'We won this tournament ... Many more to go',
            type: StoryItemType.text,
        ),
        /// For Web Story Item
        StoryItem(
            url:'https://devkrest.com/',
            type: StoryItemType.web,
        ),
        /// For Custom Story Item
        StoryItem(
            customWidget: YourOwnBakedStoryWidget(),
            type: StoryItemType.custom,
        ),
    ]
)
```

### `FlutterStoryView` Properties
Here are some of the properties you may have look for further customisations & callbacks.

```dart
/// List of StoryItem objects to display in the story view.
final List<StoryItem> items;

/// Controller for managing the current playing media.
final FlutterStoryViewController? flutterStoryViewController;

/// Callback function triggered whenever the story changes or the user navigates to the previous/next story.
final OnStoryChanged? onStoryChanged;

/// Callback function triggered when all items in the list have been played.
final OnCompleted? onCompleted;

/// Callback function triggered when the user taps on the left half of the screen.
final OnLeftTap? onLeftTap;

/// Callback function triggered when the user taps on the right half of the screen.
final OnRightTap? onRightTap;

/// Callback function triggered when user drag downs the storyview.
final OnSlideDown? onSlideDown;

/// Callback function triggered when user starts drag downs the storyview.
final OnSlideStart? onSlideStart;

/// Indicates whether the story view should restart from the beginning after all items have been played.
final bool restartOnCompleted;

/// Index to start playing the story from initially.
final int initialIndex;

/// Configuration and styling options for the story view indicator.
final StoryViewIndicatorConfig? storyViewIndicatorConfig;

/// Callback function to retrieve the VideoPlayerController when it is initialized and ready to play.
final OnVideoLoad? onVideoLoad;

/// Widget to display user profile or other details at the top of the screen.
final Widget? headerWidget;

/// Widget to display text field or other content at the bottom of the screen.
final Widget? footerWidget;
```

### Using `FlutterStoryViewController` 
`FlutterStoryViewController` is a controller class designed to manage the current story displayed on `FlutterStoryView`. It includes various methods such as `play()`, `pause()`, `jumpTo()`, `next()`, `previous()`, `mute(),` and `unMute()`, allowing you to control the existing StoryItem.

```dart
final storyController = FlutterStoryController();
FlutterStoryView(
    controller : storyController,
    items: [
        /// Story Item goes here
    ]
)
...
/// Somewhere in your code
storyController.pause();
storyController.play();
storyController.next();
storyController.previous();
storyController.jumpTo(2);
storyController.mute();
storyController.unMute();
```