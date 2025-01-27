import 'package:flutter/material.dart';
import 'package:unplug_story/model/story.dart';
import 'package:unplug_story/widget/story_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: StoryWidget(
            stories: Story.exampleUrls,
            titleBuilder: (Story story) => Text(
              story.title,
            ),
          ),
        ),
      ),
    );
  }
}
