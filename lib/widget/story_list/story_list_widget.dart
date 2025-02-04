import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unplug_story/model/story_media.dart';
import 'package:unplug_story/util/story_page_route_builder.dart';
import 'package:unplug_story/util/type.dart';
import 'package:unplug_story/widget/story_detail/story_detail_widget.dart';

import '../../model/story.dart';

/// A horizontal list widget that displays a collection of stories.
///
/// This widget creates a scrollable horizontal list of story previews, similar to
/// Instagram stories. Each story preview consists of a cover image and a title.
/// Tapping on a story opens it in a full-screen view using [StoryDetailWidget].
///
/// Example usage:
/// ```dart
/// StoryListWidget(
///   stories: myStories,
///   separatorSize: 10,
///   gapSize: 8,
/// )
/// ```
final class StoryListWidget extends StatelessWidget {
  /// Creates a new [StoryListWidget].
  ///
  /// Parameters:
  /// * [stories] - Required list of stories to display
  /// * [titleBuilder] - Optional custom builder for story titles
  /// * [coverBuilder] - Optional custom builder for story cover images
  /// * [separatorSize] - Horizontal space between story items (default: 8)
  /// * [gapSize] - Vertical space between elements in a story item (default: 8)
  /// * [bottomButtonTitleBuilder] - Optional custom builder for bottom button titles
  /// * [onBottomButtonTap] - Optional callback when bottom button is tapped
  const StoryListWidget({
    super.key,
    required this.stories,
    this.titleBuilder,
    this.coverBuilder,
    this.separatorSize = 8,
    this.gapSize = 8,
    this.bottomButtonTitleBuilder,
    this.onBottomButtonTap,
    this.storyTitleBuilder,
  });

  /// The list of stories to display.
  final List<Story> stories;

  /// Custom builder for story title widgets.
  ///
  /// If null, a default title widget will be used.
  final StoryWidgetBuilder? titleBuilder;

  /// Custom builder for story info widgets.
  ///
  /// If null, a default info widget will be used.
  final StoryWidgetBuilder? storyTitleBuilder;

  /// Custom builder for story cover image widgets.
  ///
  /// If null, a default circular cover image will be used.
  final StoryWidgetBuilder? coverBuilder;

  /// The horizontal space between story items.
  final double separatorSize;

  /// The vertical space between elements (cover, title) in a story item.
  final double gapSize;

  /// Custom builder for bottom button title widgets in story detail view.
  final StoryMediaWidgetBuilder? bottomButtonTitleBuilder;

  /// Callback function when bottom button is tapped in story detail view.
  final ValueSetter<StoryMedia>? onBottomButtonTap;

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
                  onBottomButtonTap: onBottomButtonTap,
                  bottomButtonTitleBuilder: bottomButtonTitleBuilder,
                  storyTitleBuilder: storyTitleBuilder,
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

/// Default widget for displaying a story's cover image.
///
/// Shows a circular avatar with the story's cover image using [CachedNetworkImageProvider].
final class _DefaultCoverWidget extends StatelessWidget {
  const _DefaultCoverWidget({
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: story.coverImageUrl + story.title,
      child: CircleAvatar(
        radius: 35,
        backgroundImage: CachedNetworkImageProvider(story.coverImageUrl),
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }
}

/// Default widget for displaying a story's title.
///
/// Shows the story title with ellipsis overflow using the theme's titleMedium style.
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
