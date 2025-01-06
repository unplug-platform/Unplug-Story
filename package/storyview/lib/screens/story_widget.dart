import 'package:flutter/material.dart';
import 'package:storyview/screens/story.dart';
import 'package:storyview/screens/story_detail_screen.dart';

class StoryListView<T> extends StatelessWidget {
  final List<Story> stories;
  final FontWeight? titleFontWeight;
  final double? titleFontSize;
  final Color? titleColor;

  const StoryListView({
    Key? key,
    required this.stories,
    this.titleFontWeight,
    this.titleFontSize,
    this.titleColor,
  }) : super(key: key);

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
                  Text(
                    story.title,
                    style: TextStyle(
                      color: titleColor ?? Colors.black,
                      fontSize: titleFontSize ?? 12,
                      fontWeight: titleFontWeight ?? FontWeight.w500,
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
