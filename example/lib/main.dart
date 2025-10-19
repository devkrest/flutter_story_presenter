import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
      home: const Demo(), // Ultra-simple demo - just widgets!
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

  // Just a simple list of widgets - no wrappers needed!
  final List<Widget> stories = [
    // Story 1: Video Widget
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.blue],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Story 1: Video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This is a video story widget',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
    
    // Story 2: Audio Widget
    AudioCustomView1(
      controller: null,
      audioPlayer: null,
    ),
    
    // Story 3: Image Widget
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            "https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg?auto=compress&cs=tinysrgb&w=800",
          ),
        ),
      ),
      child: const Center(
        child: Text(
          'Story 3: Beautiful Landscape',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    ),
    
    // Story 4: Interactive Widget
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange, Colors.red],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Story 4: Interactive',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tap and hold to pause',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
    
    // Story 5: Post Widget
    PostOverlayView(
      controller: null,
    ),
    
    // Story 6: Text Widget
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepOrange,
            Colors.white,
            Colors.green
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Story 6: Happy Independence Day",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Celebrating Freedom",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    ),
    
    // Story 7: Question Widget
    TextOverlayView(
      controller: null,
    ),
    
    // Story 8: Web Widget
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.purple],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.web, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Story 8: Web Content',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Loading web content...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
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
      resizeToAvoidBottomInset: false,
      body: FlutterStoryPresenterWidgets(
        flutterStoryController: FlutterStoryController(),
        widgets: stories, // Just pass widgets directly!
        defaultDuration: const Duration(seconds: 4),
        storyViewIndicatorConfig: const StoryViewIndicatorConfig(
          height: 4,
          activeColor: Colors.white,
          backgroundCompletedColor: Colors.white,
          backgroundDisabledColor: Colors.white54,
        ),
        onStoryChanged: (index) {
          print('Story changed to index: $index');
        },
        onCompleted: () async {
          print('All stories completed');
        },
      ),
    );
  }
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
                        //ignore: deprecated_member_use
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
                        //ignore: deprecated_member_use
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
                                //ignore: deprecated_member_use
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
                          //ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        )
                      ]),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://devkrest.com/flutter_story_presenter/devkrest_logo_outlined.png',
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
                    //ignore: deprecated_member_use
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
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://devkrest.com/flutter_story_presenter/devkrest_logo_outlined.png',
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
                          'https://images.pexels.com/photos/3719037/pexels-photo-3719037.jpeg'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      "Tech Meetup - Flutter Devs",
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
                  //ignore: deprecated_member_use
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
                              //ignore: deprecated_member_use
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
                        "Andy Jane",
                        style: TextStyle(
                          //ignore: deprecated_member_use
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

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late FlutterStoryController controller;

  // Just a simple list of widgets - no wrappers, no configurations!
  final List<Widget> stories = [
    // Text Widget
    Container(
      color: Colors.red,
      child: const Center(
        child: Text(
          'Story 1: Red',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    
    // Image Widget
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            'https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg?auto=compress&cs=tinysrgb&w=800',
          ),
        ),
      ),
      child: const Center(
        child: Text(
          'Story 2: Image',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    ),
    
    // Column Widget
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.blue],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Story 3: Column',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This is a column widget',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
    
    // Interactive Widget
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange, Colors.red],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Story 4: Interactive',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tap and hold to pause',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    controller = FlutterStoryController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Demo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => controller.play(),
            icon: const Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () => controller.pause(),
            icon: const Icon(Icons.pause),
          ),
          IconButton(
            onPressed: () => controller.next(),
            icon: const Icon(Icons.skip_next),
          ),
          IconButton(
            onPressed: () => controller.previous(),
            icon: const Icon(Icons.skip_previous),
          ),
        ],
      ),
      body: FlutterStoryPresenterWidgets(
        flutterStoryController: controller,
        widgets: stories, // Just pass widgets directly - that's it!
        defaultDuration: const Duration(seconds: 3),
        onStoryChanged: (index) {
          print('Story changed to index: $index');
        },
        onCompleted: () async {
          print('All stories completed');
        },
      ),
    );
  }
}