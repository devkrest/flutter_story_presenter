import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterstoryview/flutterstoryview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = FlutterStoryViewController();
  List<StoryItem> items = <StoryItem>[];

  @override
  void initState() {
    items = [
      const StoryItem(
        url: 'assets/screen_1.jpg',
        storyItemType: StoryItemType.image,
        storyItemSource: StoryItemSource.asset,
      ),
      const StoryItem(
        url: 'assets/screen_2.jpg',
        storyItemType: StoryItemType.image,
        storyItemSource: StoryItemSource.asset,
      ),
      const StoryItem(
        url: 'assets/movie_1.MP4',
        storyItemType: StoryItemType.video,
        isMuteByDefault: true,
        storyItemSource: StoryItemSource.asset,
      ),
      StoryItem(
        url: 'https://picsum.photos/2000/4000',
        storyItemType: StoryItemType.image,
        storyItemSource: StoryItemSource.network,
        imageConfig: StoryViewImageConfig(
          fit: BoxFit.cover,
          height: 300,
          width: 300,
          progressIndicatorBuilder: (p0, p1, p2) => const Center(
            child: Text(
              'Hello',
            ),
          ),
        ),
      ),
      const StoryItem(
          url: 'assets/screen_3.jpg',
          storyItemType: StoryItemType.image,
          storyItemSource: StoryItemSource.asset),
      StoryItem(
          url: 'assets/screen_4.jpg',
          storyItemType: StoryItemType.image,
          storyItemSource: StoryItemSource.asset,
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.cover,
            progressIndicatorBuilder: (p0, p1, p2) => const Center(
              child: CircularProgressIndicator(),
            ),
          )),
      StoryItem(
          url: 'https://picsum.photos/3300/2000',
          storyItemType: StoryItemType.image,
          storyItemSource: StoryItemSource.network,
          imageConfig: StoryViewImageConfig(
            fit: BoxFit.contain,
            height: 300,
            width: 300,
            progressIndicatorBuilder: (p0, p1, p2) => const Center(
                child: Text(
              'Hello',
            )),
          )),
      const StoryItem(
        url:
            'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
        storyItemType: StoryItemType.video,
        storyItemSource: StoryItemSource.network,
      ),
      const StoryItem(
        url:
            'https://videos.pexels.com/video-files/7297870/7297870-hd_1080_1920_30fps.mp4',
        storyItemType: StoryItemType.video,
        storyItemSource: StoryItemSource.network,
      ),
      StoryItem(
        url: 'Developed by Devkrest',
        textConfig: StoryViewTextConfig(
          backgroundColor: Colors.purple[50]!,
          textAlignment: Alignment.center,
          backgroundWidget: Image.asset('assets/screen_1.jpg'),
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
        ),
        storyItemType: StoryItemType.text,
      ),
    ];
    // downloadImage();
    downloadVideo();
    super.initState();
  }

  Future<void> downloadImage() async {
    try {
      final path = await getTemporaryDirectory();
      final absPath = join(path.path, 'test_file.png');
      await Dio().download('https://picsum.photos/5000/5000', absPath);
      items.add(
        StoryItem(
            url: absPath,
            storyItemType: StoryItemType.image,
            duration: const Duration(seconds: 10),
            storyItemSource: StoryItemSource.file,
            imageConfig: StoryViewImageConfig(
              progressIndicatorBuilder: (p0, p1, p2) => const Center(
                child: CupertinoActivityIndicator(),
              ),
            )),
      );
      setState(() {});
    } catch (err) {
      debugPrint('$err');
    }
  }

  Future<void> downloadVideo() async {
    try {
      final path = await getApplicationDocumentsDirectory();
      final absPath = join(path.path, 'test_video1.mp4');
      await Dio().download(
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          absPath);
      items.add(
        StoryItem(
            url: absPath,
            storyItemType: StoryItemType.video,
            storyItemSource: StoryItemSource.file,
            imageConfig: StoryViewImageConfig(
              progressIndicatorBuilder: (p0, p1, p2) => const Center(
                child: CupertinoActivityIndicator(),
              ),
            )),
      );
      setState(() {});
    } catch (err) {
      debugPrint('Errror downloading video $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterStoryView(
            items: items,
            flutterStoryViewController: controller,
            storyViewIndicatorConfig: const StoryViewIndicatorConfig(
              backgroundDisabledColor: Colors.blue,
              backgroundCompletedColor: Colors.yellow,
              activeColor: Colors.red,
              alignment: Alignment.topCenter,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: controller.pause, child: const Text("Pause")),
                  ElevatedButton(
                      onPressed: controller.play, child: const Text("Resume")),
                  ElevatedButton(
                      onPressed: controller.mute, child: const Text("Mute")),
                  ElevatedButton(
                      onPressed: () => controller.jumpTo(10),
                      child: const Text("Jumpto")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
