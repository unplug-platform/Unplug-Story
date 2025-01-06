import 'package:flutter/material.dart';
import 'package:storyview/screens/story.dart';
import 'package:storyview/screens/story_widget.dart';
import 'package:storyview/storyview.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Story> stories = [
      Story(
        title: "John's Adventure",
        coverImageUrl: 'https://picsum.photos/800/1600?3',
        urls: [
          UrlItem(url: 'https://picsum.photos/800/1600?1', isVideo: false),
          UrlItem(url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', isVideo: true),
          UrlItem(url: 'https://picsum.photos/800/1600?2', isVideo: false),
          UrlItem(url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', isVideo: true),
        ],
      ),
      Story(
        title: "Emily's Trip",
        coverImageUrl: 'https://picsum.photos/800/1600?3',
        urls: [
          UrlItem(url: 'https://picsum.photos/800/1600?2', isVideo: false),
          UrlItem(url: 'https://picsum.photos/800/1600?3', isVideo: false),
          UrlItem(url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', isVideo: true),
        ],
      ),
      Story(
        title: "Mike's Adventure",
        coverImageUrl: 'https://picsum.photos/800/1600?4',
        urls: [
          UrlItem(url: 'https://picsum.photos/800/1600?4', isVideo: false),
        ],
      ),
      Story(
        title: "Anna's Day Out",
        coverImageUrl: 'https://picsum.photos/800/1600?5',
        urls: [
          UrlItem(url: 'https://picsum.photos/800/1600?5', isVideo: false),
        ],
      ),
    ];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: StoryListView(
          stories: stories,
        ),
      ),
    );
  }
}
