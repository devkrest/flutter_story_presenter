import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

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

  //Story Data
  List<StoryModel> sampleStory = [
    StoryModel(
      userName: 'Kaival Patel',
      userProfile: 'https://avatars.githubusercontent.com/u/39383435?v=4',
      stories: [
        const StoryItem(
          storyItemType: StoryItemType.video,
          storyItemSource: StoryItemSource.asset,
          url: 'assets/fb8512a35d6f4b2e8917b74a048de71a.MP4',
          thumbnail: Center(
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
          videoConfig: StoryViewVideoConfig(
            fit: BoxFit.cover,
          ),
        ),
        const StoryItem(
            storyItemType: StoryItemType.video,
            url:
                'https://videos.pexels.com/video-files/5913245/5913245-uhd_1440_2560_30fps.mp4',
            thumbnail: Center(
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
            videoConfig: StoryViewVideoConfig(
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              loadingWidget: Center(child: CupertinoActivityIndicator()),
            )),
        StoryItem(
          storyItemType: StoryItemType.custom,
          customWidget: (p0) => TextOverlayView(
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
          customWidget: (p0) => PostOverlayView(
            controller: p0,
          ),
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.contain,
            progressIndicatorBuilder: (p0, p1, p2) => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
        const StoryItem(
          storyItemType: StoryItemType.video,
          storyItemSource: StoryItemSource.asset,
          url: 'assets/StorySaver.net-_spindia_-Video-1718781607686.mp4',
          thumbnail: Center(
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
          videoConfig: StoryViewVideoConfig(
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
          storyItemType: StoryItemType.web,
          url: 'https://quirkywanderer.com/web-stories/bijli-mahadev-trek/',
          duration: const Duration(seconds: 20),
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.contain,
            progressIndicatorBuilder: (p0, p1, p2) => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: sampleStory.length,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemBuilder: (context, index) {
          return MyStoryView(
            storyModel: sampleStory[index],
            pageController: pageController,
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

    return FlutterStoryView(
      flutterStoryController: controller,
      items: widget.storyModel.stories,
      footerWidget: MessageBoxView(controller: controller),
      storyViewIndicatorConfig: storyViewIndicatorConfig,
      initialIndex: 0,
      headerWidget: ProfileView(storyModel: widget.storyModel),
      onStoryChanged: (p0) {
        // For Custom type story need to play custom view manually
        if (widget.storyModel.stories[p0].storyItemType ==
            StoryItemType.custom) {
          controller.playCustomWidget();
        }
      },
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
                    TapRegion(
                      onTapOutside: (event) {
                        controller?.play();
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: IntrinsicWidth(
                          child: TextFormField(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onTap: () {
                              controller?.pause();
                            },
                            decoration: InputDecoration(
                                hintText: 'Type something...',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                border: InputBorder.none),
                          ),
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
                      imageUrl:
                          'https://scontent.cdninstagram.com/v/t51.29350-15/448680084_2197193763952189_5110658492947027914_n.webp?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDE4MDAuc2RyLmYyOTM1MCJ9&_nc_ht=scontent.cdninstagram.com&_nc_cat=1&_nc_ohc=VtYwOfs3y44Q7kNvgEfDjM0&edm=APs17CUBAAAA&ccb=7-5&ig_cache_key=MzM5MzIyNzQ4MjcwNjA5NzYzNQ%3D%3D.2-ccb7-5&oh=00_AYAEOmKhroMeZensvVXMuCbC8rB0vr_0P7-ecR8AKLk5Lw&oe=6678548B&_nc_sid=10d13b'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      "India vs Afganistan",
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
