import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unplug_story/widget/story_detail/story_detail_widget.dart';
import 'package:unplug_story/widget/story_page_route_builder.dart';

import '../../model/story.dart';

typedef StoryWidgetBuilder = Widget Function(Story story);

final class StoryListWidget extends StatelessWidget {
  const StoryListWidget({
    super.key,
    required this.stories,
    this.titleBuilder,
    this.coverBuilder,
    this.separatorSize = 8,
    this.gapSize = 8,
  });

  final List<Story> stories;
  final StoryWidgetBuilder? titleBuilder;
  final StoryWidgetBuilder? coverBuilder;
  final double separatorSize;
  final double gapSize;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: stories.length,
      separatorBuilder: (context, index) => SizedBox(width: separatorSize),
      itemBuilder: (context, index) {
        final story = stories[index];
        return GestureDetector(
          onTapUp: (details) {
            Navigator.push(
              context,
              StoryPageRouteBuilder(
                tapPosition: details.globalPosition,
                pageBuilder: (context, animation, secondaryAnimation) => StoryDetailWidget(
                  stories: stories,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: gapSize),
              coverBuilder != null ? coverBuilder!(story) : _DefaultCoverWidget(story: story),
              SizedBox(height: gapSize),
              titleBuilder != null ? titleBuilder!(story) : _DefaultTitleWidget(story: story),
              SizedBox(height: gapSize),
            ],
          ),
        );
      },
    );
  }
}

final class _DefaultCoverWidget extends StatelessWidget {
  const _DefaultCoverWidget({
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundImage: CachedNetworkImageProvider(story.coverImageUrl),
      backgroundColor: Colors.grey.shade800,
    );
  }
}

final class _DefaultTitleWidget extends StatelessWidget {
  const _DefaultTitleWidget({
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Text(
      story.title,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
