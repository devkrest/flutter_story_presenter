# FlutterStoryPresenter

![FlutterStoryPresenter](https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/flutter_story_presenter.png)

This Flutter package makes it easy to create story and news views like popular social media apps
with just a few lines of code! 📱✨ It's loaded with features for customizing and managing stories,
perfect for showcasing stories inside your awesome app.

## ✨ Demo

![Video Story](https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/video_story.gif)![Image Story](https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/image_story.gif)
![Web Story](https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/web_story.gif)
![Custom Story 1](https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/custom_story_1.gif) ![Custom Story 2](https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/custom_story_2.gif)
![Audio Story](https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/audio_story.gif)

## 🎥 Video Demo

https://devkrest.com/github/flutter-story-presenter-demo.mp4

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

🔹 **Callbacks**: Receive different callbacks based on the type of story item for handling state
management.

## ⚙️ Installation

Add `flutter_story_presenter` to your `pubspec.yaml` dependencies. And Import it as

```dart
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
```

## 🔭 Guide to use

For a detailed view and more examples, check out `example/main.dart`.

Use `FlutterStoryPresenter` to display stories on any screen. It accepts a list of `StoryItem`, each
containing URLs for displaying images, videos, and web pages.

```dart
FlutterStoryPresenter(
      flutterStoryController: FlutterStoryController(),
      items: [
        /// For Image Story Item
        StoryItem(
          url: 'https://picsum.photos/1000/1000',
          storyItemType: StoryItemType.image,
        ),

        /// For Video Story Item
        StoryItem(
          url:
              'https://videos.pexels.com/video-files/7297870/7297870-hd_1080_1920_30fps.mp4',
          storyItemType: StoryItemType.video,
        ),

        /// For Text Story Item
        StoryItem(
          url: 'We won this tournament ... Many more to go',
          storyItemType: StoryItemType.text,
        ),

        /// For Web Story Item
        StoryItem(
          url: 'https://devkrest.com/',
          storyItemType: StoryItemType.web,
        ),

        /// For Custom Story Item
        StoryItem(
          customWidget: YourOwnBakedStoryWidget(),
          storyItemType: StoryItemType.custom,
        ),
      ],
    );
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

`FlutterStoryController` is a controller class designed to manage the current story displayed
on `FlutterStoryPresenter`. It includes various methods such
as `play()`, `pause()`, `jumpTo()`, `next()`, `previous()`, `mute(),` and `unMute()`, allowing you
to control the existing StoryItem.

```dart

final storyController = FlutterStoryController();
FlutterStoryPresenter(
      flutterStoryController: storyController,
      items: [
        /// Story Item goes here
      ],
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

The `StoryItem` class is used to define the individual items displayed in a `FlutterStoryPresenter`.
Each `StoryItem` can represent an image, video, text, web content, or a custom widget.

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
    this.audioConfig,
  });
```

#### Parameters

- **url**: The URL, file path, or web URL of the story item. Required unless `storyItemType`
  is `custom`.
- **storyItemType**: The type of story item. Required. It can be an image, video, text, web content,
  or custom.
- **thumbnail**: A widget to display as a thumbnail.
- **isMuteByDefault**: A boolean indicating whether the video should be muted by default. Applicable
  when `storyItemType` is `video`.
- **duration**: The duration for displaying the widget. Defaults to 3 seconds.
- **storyItemSource**: The source type of the story item. Defaults to `StoryItemSource.network`.
- **videoConfig**: Configuration for video stories.
- **audioConfig**: Configuration for audio if you want to play audio in text story, image story or
  in custom story type.
- **errorWidget**: A widget to display when an error occurs while loading the view.
- **imageConfig**: Configuration for image stories.
- **textConfig**: Configuration for text stories.
- **webConfig**: Configuration for web stories.
- **customWidget**: A custom widget to display fully instead of any other view. Required
  when `storyItemType` is `custom`.

#### Example

```dart
StoryItem(
  url: 'https://example.com/image.jpg',
  storyItemType: StoryItemType.image,
  storyItemSource: StoryItemSource.network,
  duration: const Duration(seconds: 5),
  thumbnail: Image.network('https://example.com/thumbnail.jpg'),
  imageConfig: StoryViewImageConfig(
    fit: BoxFit.cover,
    height: 300,
    width: 300,
    progressIndicatorBuilder: (_, _, loadProgress) {
      return YourImageLoaderWidget();
    },
  ),
),
StoryItem(
  url: 'https://example.com/video.mp4',
  storyItemType: StoryItemType.video,
  isMuteByDefault: true,
  storyItemSource: StoryItemSource.network,
  duration: const Duration(seconds: 10),
  videoConfig: StoryViewVideoConfig(
    fit: BoxFit.cover,
    height: 500,
    width: 500,
    loadingWidget: MyVideoLoadingWidget(),
    // If you opt to cache video,
    // it will store to user device and then played,
    // if already cached, will play without buffer
    // from next time
    cacheVideo: true,
    useVideoAspectRatio: false,
    videoPlayerOptions: VideoPlayerOptions(
      mixWithOthers: true,
    ),
  ),
),
StoryItem(
  storyItemType: StoryItemType.custom,
  customWidget: MyCustomWidget(),
),
```

### Full Example

This is the full example demonstrating the usage of `FlutterStoryPresenter`. For more insights and
detailed reference, refer to
the [official documentation](https://github.com/devkrest/flutter_story_presenter/blob/22-setState-unpauses-flutterstorycontroller/example/lib/main.dart).

```dart
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController();
  double currentPageValue = 0.0;

  //Story Data
  List<StoryModel> sampleStory = [
    StoryModel(
      userName: 'Kaival Patel',
      userProfile: 'https://avatars.githubusercontent.com/u/39383435?v=4',
      stories: [
        StoryItem(
          storyItemType: StoryItemType.custom,
          audioConfig: StoryViewAudioConfig(
            audioPath: 'https://audios.ftcdn.net/08/98/82/47/48K_898824706.m4a',
            source: StoryItemSource.network,
            onAudioStart: (p0) {},
          ),
          customWidget: (p0, audioPlayer) => AudioCustomView1(
            controller: p0,
            audioPlayer: audioPlayer,
          ),
        ),
        StoryItem(
          storyItemType: StoryItemType.image,
          url:
              "https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg?auto=compress&cs=tinysrgb&w=800",
        ),
        StoryItem(
          storyItemType: StoryItemType.video,
          storyItemSource: StoryItemSource.asset,
          url: 'assets/fb8512a35d6f4b2e8917b74a048de71a.MP4',
          thumbnail: const Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(
                radius: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Video Loading')
            ],
          )),
          videoConfig: const StoryViewVideoConfig(
            fit: BoxFit.cover,
          ),
        ),
        StoryItem(
            storyItemType: StoryItemType.video,
            url:
                'https://videos.pexels.com/video-files/5913245/5913245-uhd_1440_2560_30fps.mp4',
            thumbnail: const Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(
                  radius: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Video Loading')
              ],
            )),
            videoConfig: const StoryViewVideoConfig(
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              loadingWidget: Center(child: CupertinoActivityIndicator()),
            )),
        StoryItem(
          storyItemType: StoryItemType.custom,
          duration: const Duration(seconds: 20),
          customWidget: (p0, audioPlayer) => PostOverlayView(
            controller: p0,
          ),
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.contain,
            progressIndicatorBuilder: (p0, p1, p2) => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
      ],
    ),
    StoryModel(
      userName: 'Lakhan P.',
      userProfile: 'https://devkrest.com/team/lakhan.png',
      stories: [
        StoryItem(
          storyItemType: StoryItemType.custom,
          duration: const Duration(seconds: 20),
          customWidget: (p0, audioPlayer) => PostOverlayView(
            controller: p0,
          ),
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.contain,
            progressIndicatorBuilder: (p0, p1, p2) => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
        StoryItem(
          storyItemType: StoryItemType.video,
          storyItemSource: StoryItemSource.asset,
          url: 'assets/StorySaver.net-_spindia_-Video-1718781607686.mp4',
          thumbnail: const Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(
                radius: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Video Loading')
            ],
          )),
          videoConfig: const StoryViewVideoConfig(
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
    StoryModel(
      userName: 'Harsh P.',
      userProfile: 'https://devkrest.com/team/harsh.jpg',
      stories: [
        StoryItem(
          storyItemType: StoryItemType.text,
          textConfig: StoryViewTextConfig(
              textWidget: const Text(
                "Happy Independence Day",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontStyle: FontStyle.italic),
              ),
              backgroundWidget: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.deepOrange,
                      Colors.white,
                      Colors.green
                    ])),
              )),
          url: "Happy Independence Day",
        ),
        StoryItem(
          storyItemType: StoryItemType.web,
          url:
              'https://www.ndtv.com/webstories/travel/10-things-to-do-in-amritsar-from-golden-temple-visit-to-wagah-border-47',
          duration: const Duration(seconds: 20),
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.contain,
            progressIndicatorBuilder: (p0, p1, p2) => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  multiStoryView() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: sampleStory.length,
        // physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: pageController,
            child: MyStoryView(
              storyModel: sampleStory[index],
              pageController: pageController,
            ),
            builder: (context, child) {
              if (pageController.position.hasContentDimensions) {
                currentPageValue = pageController.page ?? 0.0;
                final isLeaving = (index - currentPageValue) <= 0;
                final t = (index - currentPageValue);
                final rotationY = lerpDouble(0, 30, t)!;
                const maxOpacity = 0.8;
                final num opacity =
                    lerpDouble(0, maxOpacity, t.abs())!.clamp(0.0, maxOpacity);
                final isPaging = opacity != maxOpacity;
                final transform = Matrix4.identity();
                transform.setEntry(3, 2, 0.003);
                transform.rotateY(-rotationY * (pi / 180.0));
                return Transform(
                  alignment:
                      isLeaving ? Alignment.centerRight : Alignment.centerLeft,
                  transform: transform,
                  child: Stack(
                    children: [
                      child!,
                      if (isPaging && !isLeaving)
                        Positioned.fill(
                          child: Opacity(
                            opacity: opacity as double,
                            child: const ColoredBox(
                              color: Colors.black87,
                            ),
                          ),
                        )
                    ],
                  ),
                );
              }

              return child!;
            },
          );
        },
      ),
    );
  }
}

class MyStoryView extends StatefulWidget {
  const MyStoryView({
    super.key,
    required this.storyModel,
    required this.pageController,
  });

  final StoryModel storyModel;
  final PageController pageController;

  @override
  State<MyStoryView> createState() => _MyStoryViewState();
}

class _MyStoryViewState extends State<MyStoryView> {
  late FlutterStoryController controller;

  @override
  void initState() {
    controller = FlutterStoryController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyViewIndicatorConfig = StoryViewIndicatorConfig(
      height: 4,
      activeColor: Colors.white,
      backgroundCompletedColor: Colors.white,
      backgroundDisabledColor: Colors.white.withOpacity(0.5),
      horizontalGap: 1,
      borderRadius: 1.5,
    );
    return FlutterStoryPresenter(
      flutterStoryController: controller,
      items: widget.storyModel.stories,
      footerWidget: MessageBoxView(controller: controller),
      storyViewIndicatorConfig: storyViewIndicatorConfig,
      initialIndex: 0,
      headerWidget: ProfileView(storyModel: widget.storyModel),
      onStoryChanged: (p0) {},
      onPreviousCompleted: () async {
        await widget.pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate);
      },
      onCompleted: () async {
        await widget.pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate);
        controller = FlutterStoryController();
      },
    );
  }
}

class MessageBoxView extends StatelessWidget {
  const MessageBoxView({
    super.key,
    required this.controller,
  });

  final FlutterStoryController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  onTap: () {
                    controller.pause();
                  },
                  onTapOutside: (event) {
                    controller.play();
                    FocusScope.of(context).unfocus();
                  },
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                      hintText: 'Enter Message',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6)),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            IconButton(
                onPressed: () {},
                iconSize: 30,
                icon: Transform.rotate(
                    angle: -0.6,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.storyModel,
  });

  final StoryModel storyModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(1),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: storyModel.userProfile,
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      storyModel.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.verified,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text(
                    '1d',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Custom Story Data Model
class StoryModel {
  String userName;
  String userProfile;
  List<StoryItem> stories;

  StoryModel({
    required this.userName,
    required this.userProfile,
    required this.stories,
  });
}

// Custom Widget - Question
class TextOverlayView extends StatelessWidget {
  const TextOverlayView({super.key, required this.controller});

  final FlutterStoryController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                  'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 0,
                      )
                    ]),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "What’s your favorite outdoor activity and why?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: IntrinsicWidth(
                        child: TextFormField(
                          onTap: () {
                            controller?.pause();
                          },
                          onTapOutside: (event) {
                            // controller?.play();
                            FocusScope.of(context).unfocus();
                          },
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Type something...',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: -40,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffE2DCFF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        )
                      ]),
                  padding: const EdgeInsets.all(20),
                  child: CachedNetworkImage(
                    imageUrl: 'https://devkrest.com/logo/devkrest_outlined.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Widget - Post View
class PostOverlayView extends StatelessWidget {
  const PostOverlayView({super.key, required this.controller});

  final FlutterStoryController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xffff8800), Color(0xffff3300)])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 0,
                    spreadRadius: 0,
                  )
                ]),
            child: IntrinsicWidth(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffE2DCFF),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://devkrest.com/logo/devkrest_outlined.png',
                            height: 15,
                            width: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Expanded(
                          child: Text(
                            'devkrest',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_horiz,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.40,
                    fit: BoxFit.cover,
                    imageUrl: 'https://picsum.photos/500/500',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      "Random Image (Courtesy:picsum.photos)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Widget - Audio View - 1
class AudioCustomView1 extends StatelessWidget {
  const AudioCustomView1(
      {super.key, required this.controller, this.audioPlayer});

  final FlutterStoryController? controller;
  final AudioPlayer? audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                  'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 130,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/img.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    StreamBuilder<bool>(
                        stream: audioPlayer?.playingStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == false) {
                            return const SizedBox();
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.54),
                            ),
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/audio-anim__.gif',
                              fit: BoxFit.cover,
                            ),
                          );
                        })
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Don't Give Up on Me",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Andy grammer",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


```

## Team Devkrest

We would like to extend our heartfelt thanks to the following contributors for their invaluable
contributions to this package.
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
        <img src="https://raw.githubusercontent.com/devkrest/flutter_story_presenter/22-setState-unpauses-flutterstorycontroller/assets/devkrest_footer.png" 
        style="margin-top:8px"
         alt="Devkrest Technologies"/><br />
      </a>
    </td>
  </tr>
</table>