import 'package:flutter/material.dart';
import 'package:unplug_story/model/story.dart';
import 'package:unplug_story/model/story_media.dart';
import 'package:unplug_story/widget/story_list/story_list_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
                onBottomButtonTap: (StoryMedia storyMedia) async {
                  final url = storyMedia.bottomButtonUrl;
                  if (url == null) return;
                  if (url.isEmpty) return;
                  final result = await launchUrl(Uri.parse(url));
                  if (!context.mounted) return;
                  if (!result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to launch URL')),
                    );
                  }
                },
              ),
            ),
            Expanded(
              flex: 4,
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
