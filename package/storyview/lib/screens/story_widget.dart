import 'package:flutter/material.dart';
import 'package:storyview/screens/story.dart';
import 'package:storyview/screens/story_detail_screen.dart';

final class StoryListView extends StatelessWidget {
  final List<Story> stories;
  final Widget Function(Story story)? titleBuilder;

  const StoryListView({
    super.key,
    required this.stories,
    this.titleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryDetailScreen(
                    stories: stories,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(story.coverImageUrl),
                    backgroundColor: Colors.grey.shade800,
                  ),
                  const SizedBox(height: 8),
                  titleBuilder != null ? titleBuilder!(story) : Text(
                    story.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
