import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
      home: Home(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: sampleStory.length,
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
  late final FlutterStoryController controller;

  @override
  void initState() {
    controller = FlutterStoryController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterStoryView(
          // flutterStoryController: sampleStory[index].controller,
          items: widget.storyModel.stories,
          footerWidget: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Enter Message',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () {},
                      iconSize: 30,
                      icon: Transform.rotate(
                          angle: -0.6, child: Icon(Icons.send)))
                ],
              ),
            ),
          ),
          storyViewIndicatorConfig: StoryViewIndicatorConfig(
            height: 4,
            activeColor: Colors.white,
            backgroundCompletedColor: Colors.white,
            backgroundDisabledColor: Colors.white.withOpacity(0.5),
            horizontalGap: 1,
            borderRadius: 1.5,
          ),
          initialIndex: 0,
          headerWidget: ProfileView(storyModel: widget.storyModel),
          onPreviousCompleted: () async {
            await widget.pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate);
          },
          onCompleted: () async {
            await widget.pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate);
          },
        ),
      ],
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
    return Padding(
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
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              storyModel.userName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
            ),
          )
        ],
      ),
    );
  }
}

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

List<StoryModel> sampleStory = [
  StoryModel(
    userName: 'Harsh',
    userProfile:
        'https://images.pexels.com/photos/1486064/pexels-photo-1486064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    stories: [
      StoryItem(
        storyItemType: StoryItemType.custom,
        customWidget: TextOverlayView(),
        imageConfig: StoryViewImageConfig(
          fit: BoxFit.contain,
        ),
      ),
      const StoryItem(
          storyItemType: StoryItemType.video,
          url:
              'https://videos.pexels.com/video-files/5913245/5913245-uhd_1440_2560_30fps.mp4',
          videoConfig: StoryViewVideoConfig(
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            loadingWidget: Center(child: CupertinoActivityIndicator()),
          )),
      const StoryItem(
          storyItemType: StoryItemType.image,
          url:
              'https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.cover,
          )),
    ],
  ),
  StoryModel(
    userName: 'Harsh',
    userProfile:
        'https://images.pexels.com/photos/5393594/pexels-photo-5393594.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    stories: [
      StoryItem(
        storyItemType: StoryItemType.text,
        textConfig: StoryViewTextConfig(
            textWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RoundedBackgroundText(
                'We build business that\n Convert \nthe idea into software',
                textAlign: TextAlign.center,
                backgroundColor: Colors.white,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            backgroundWidget: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                    Color(0xff560DFF),
                    Color(0xff73ECFF),
                  ])),
            )),
        url: '',
      ),
      const StoryItem(
          storyItemType: StoryItemType.image,
          url:
              'https://images.pexels.com/photos/207353/pexels-photo-207353.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.cover,
          )),
    ],
  ),
];

class TextOverlayView extends StatelessWidget {
  const TextOverlayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
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
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 30),
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "What’s your favorite outdoor activity and why?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: IntrinsicWidth(
                        child: TextFormField(
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
                      color: Color(0xffE2DCFF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        )
                      ]),
                  padding: EdgeInsets.all(20),
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
