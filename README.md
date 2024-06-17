# FlutterStoryPresenter

![FlutterStoryPresenter](https://devkrest.com/github/flutter_story_presenter.png)

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

Add `flutter_story_presenter` to your `pubspec.yaml` dependencies. And Import it as

```dart
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
```

## 🔭 Guide to use

For a detailed view and more examples, check out `example/main.dart`.

Use `FlutterStoryPresenter` to display stories on any screen. It accepts a list of `StoryItem`, each containing URLs for displaying images, videos, and web pages.

```dart
FlutterStoryPresenter(
    controller : FlutterStoryController(),
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

### `FlutterStoryPresenter` Properties

Here are some of the properties you may have look for further customisations & callbacks.

```dart
/// List of StoryItem objects to display in the story view.
final List<StoryItem> items;

/// Controller for managing the current playing media.
final FlutterStoryController? flutterStoryController;

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

### Using `FlutterStoryController`

`FlutterStoryController` is a controller class designed to manage the current story displayed on `FlutterStoryPresenter`. It includes various methods such as `play()`, `pause()`, `jumpTo()`, `next()`, `previous()`, `mute(),` and `unMute()`, allowing you to control the existing StoryItem.

```dart
final storyController = FlutterStoryController();
FlutterStoryPresenter(
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

### Using `StoryItem`

The `StoryItem` class is used to define the individual items displayed in a `FlutterStoryPresenter`. Each `StoryItem` can represent an image, video, text, web content, or a custom widget.

```dart
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
});
```

#### Parameters

- **url**: The URL, file path, or web URL of the story item. Required unless `storyItemType` is `custom`.
- **storyItemType**: The type of story item. Required. It can be an image, video, text, web content, or custom.
- **thumbnail**: A widget to display as a thumbnail.
- **isMuteByDefault**: A boolean indicating whether the video should be muted by default. Applicable when `storyItemType` is `video`.
- **duration**: The duration for displaying the widget. Defaults to 3 seconds.
- **storyItemSource**: The source type of the story item. Defaults to `StoryItemSource.network`.
- **videoConfig**: Configuration for video stories.
- **errorWidget**: A widget to display when an error occurs while loading the view.
- **imageConfig**: Configuration for image stories.
- **textConfig**: Configuration for text stories.
- **webConfig**: Configuration for web stories.
- **customWidget**: A custom widget to display fully instead of any other view. Required when `storyItemType` is `custom`.

#### Example

```dart
StoryItem(
  url: 'https://example.com/image.jpg',
  storyItemType: StoryItemType.image,
  storyItemSource: StoryItemSource.network,
  duration: Duration(seconds: 5),
  thumbnail: Image.network('https://example.com/thumbnail.jpg'),
  imageConfig: StoryViewImageConfig(
    fit: BoxFit.cover,
    height: 300,
    width: 300,
    progressIndicatorBuilder: (_,_,loadProgress){
      return YourImageLoaderWidget();
    }
  ),
)

StoryItem(
  url: 'https://example.com/video.mp4',
  storyItemType: StoryItemType.video,
  isMuteByDefault: true,
  storyItemSource: StoryItemSource.network,
  duration: Duration(seconds: 10),
  videoConfig: StoryViewVideoConfig(
    cacheVideo: true,
    fit: BoxFit.cover,
    height: 500,
    width: 500,
    loadingWidget: MyVideoLoadingWidget(),
    /// If you opt to cache video, 
    // it will store to user device and then played, 
    // if already cached, will play without buffer 
    // from next time
    cacheVideo: false,
    useVideoAspectRatio: false,
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,),
  ),
)

StoryItem(
  storyItemType: StoryItemType.custom,
  customWidget: MyCustomWidget(),
)
```

### Full Example
This is the full example demonstrating the usage of `FlutterStoryPresenter`. For more insights and detailed reference, refer to the [official documentation](https://github.com/devkrest/flutter_storyview).

## Team Devkrest
We would like to extend our heartfelt thanks to the following contributors for their invaluable contributions to this package.
<table>
<tr>
<td align="center">
<a href="https://github.com/Kaival-Patel">
<img src="https://avatars.githubusercontent.com/u/39383435?v=4" height="100px"; width="100px"; style="object-fit:cover;object-position:top; border-radius: 5%;" alt="Kaival Patel"/><br />
<b>Kaival P</b>
</a>
<br />
<p>CEO</p>
</td>
<td align="center">
<a href="https://github.com/harshlet">
<img src="https://devkrest.com/team/harsh.jpg" height="100px"; width="100px"; style="object-fit:cover;object-position:top; border-radius: 5%;" alt="Harsh Prajapati"/><br />
<b>Harsh P</b>
</a>
<br />
<p>Mobile Head</p>
</td>
<td align="center">
<a href="https://github.com/lakhan-purohit">
<img src="https://devkrest.com/team/lakhan.png"  height="100px"; width="100px"; style="object-fit:cover;object-position:top; border-radius: 5%;" alt="Lakhan Purohit"/><br />
<b>Lakhan P</b>
</a>
<br />
<p>CTO</p>
</td>
</tr><tr>
    <td colspan="3" align="center">
      <a href="https://devkrest.com/">
        <img src="example/assets/devkrest_logo.png" 
        style="margin-top:8px"
         alt="Devkrest Technologies"/><br />
      </a>
    </td>
  </tr>
</table>