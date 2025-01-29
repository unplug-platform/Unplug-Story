import 'package:flutter/material.dart';
import 'package:unplug_story/model/story.dart';
import 'package:unplug_story/widget/story_list/story_list_widget.dart';

void main() => runApp(const MyApp());

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unplug Story'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StoryListWidget(
                stories: Story.exampleUrls,
                titleBuilder: (Story story) => Text(
                  story.title,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
