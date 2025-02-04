import 'dart:math' show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unplug_story/unplug_story.dart';
import 'package:unplug_story/util/type.dart';
import 'package:unplug_story/widget/story_detail/story_detail_mixin.dart';
import 'package:video_player/video_player.dart';

/// A widget that displays stories in a full-screen, interactive view.
///
/// This widget provides an Instagram-like story viewing experience with:
/// * Horizontal swipe navigation between stories
/// * Tap navigation between media items
/// * Progress indicators for each media item
/// * Video playback support
/// * Interactive bottom button
/// * Gesture-based controls (tap, swipe, long press)
///
/// Example usage:
/// ```dart
/// StoryDetailWidget(
///   stories: myStories,
///   initialIndex: 0,
///   onBottomButtonTap: (media) => print('Button tapped: ${media.bottomButtonTitle}'),
/// )
/// ```
final class StoryDetailWidget extends StatefulWidget {
  /// Creates a new [StoryDetailWidget].
  ///
  /// Parameters:
  /// * [stories] - Required list of stories to display
  /// * [initialIndex] - Required initial story index to display
  /// * [onBottomButtonTap] - Optional callback when bottom button is tapped
  /// * [bottomButtonTitleBuilder] - Optional custom builder for bottom button titles
  const StoryDetailWidget({
    super.key,
    required this.stories,
    required this.initialIndex,
    this.onBottomButtonTap,
    this.bottomButtonTitleBuilder,
    this.storyTitleBuilder,
  });

  /// The list of stories to display.
  final List<Story> stories;

  /// The initial story index to display.
  final int initialIndex;

  /// Callback function when the bottom button is tapped.
  final ValueSetter<StoryMedia>? onBottomButtonTap;

  /// Custom builder for the bottom button title widget.
  final StoryMediaWidgetBuilder? bottomButtonTitleBuilder;

  /// Custom builder for the story title widget.
  final StoryWidgetBuilder? storyTitleBuilder;

  @override
  State<StoryDetailWidget> createState() => _StoryDetailWidgetState();
}

/// The state class for [StoryDetailWidget].
///
/// Uses [StoryDetailMixin] to handle core story functionality and
/// [SingleTickerProviderStateMixin] for animations.
final class _StoryDetailWidgetState extends State<StoryDetailWidget>
    with SingleTickerProviderStateMixin, StoryDetailMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onVerticalDragStart: handleDragStart,
          onVerticalDragUpdate: handleDragUpdate,
          onVerticalDragEnd: handleDragEnd,
          onTapUp: handleTapUp,
          onLongPressStart: handleLongPressStart,
          onLongPressEnd: handleLongPressEnd,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.stories.length,
            pageSnapping: true,
            physics: const ClampingScrollPhysics(),
            onPageChanged: onChanged,
            itemBuilder: (context, index) {
              final story = widget.stories[index];
              final mediaList = story.mediaList;
              final relativePosition = index - currentPage;
              final storyMediaIndex = storyMediaIndices[index] ?? 0;
              final storyMedia = mediaList[storyMediaIndex];
              final isCurrentStory = index == currentStoryIndex;

              return Transform(
                key: UniqueKey(),
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(relativePosition * -pi / 2),
                alignment: relativePosition >= 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: Stack(
                  key: ValueKey('story_stack_$index'),
                  children: [
                    storyMedia.isVideo
                        ? videoPlayerController == null
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                key: ValueKey('video_center_$index'),
                                child: AspectRatio(
                                  aspectRatio: videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController!),
                                ),
                              )
                        : CachedNetworkImage(
                            imageUrl: storyMedia.storyUrl,
                            fit: BoxFit.cover,
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).height,
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        spacing: 4,
                        children: List.generate(
                          mediaList.length,
                          (innerIndex) {
                            return Expanded(
                              child: AnimatedBuilder(
                                animation: progressController,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(2),
                                    value: isCurrentStory
                                        ? (storyMediaIndex == innerIndex
                                            ? progressController.value
                                            : storyMediaIndex > innerIndex
                                                ? 1
                                                : 0)
                                        : 0,
                                    color: Colors.white,
                                    backgroundColor: Colors.white24,
                                  );
                                },
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 8,
                      child: _StoryInfo(
                        story: story,
                        storyTitleBuilder: widget.storyTitleBuilder,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _BottomButton(
                        storyMedia: storyMedia,
                        onBottomButtonTap: widget.onBottomButtonTap,
                        bottomButtonTitleBuilder: widget.bottomButtonTitleBuilder,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A widget that displays story information (avatar and title).
///
/// Used in the top-left corner of the story detail view.
final class _StoryInfo extends StatelessWidget {
  /// Creates a new [_StoryInfo] widget.
  ///
  /// The [story] parameter is required to display the story's avatar and title.
  const _StoryInfo({
    required this.story,
    this.storyTitleBuilder,
  });

  /// The story whose information will be displayed.
  final Story story;

  /// The builder for the story info widget.
  final StoryWidgetBuilder? storyTitleBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: story.coverImageUrl + story.title,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(
              story.coverImageUrl,
            ),
          ),
        ),
        const SizedBox(width: 8),
        storyTitleBuilder != null
            ? storyTitleBuilder!(story)
            : Text(
                story.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
      ],
    );
  }
}

/// A widget that displays an interactive bottom button in the story detail view.
///
/// The button appears with an animated arrow and customizable title when
/// [StoryMedia.isBottomButtonVisible] is true.
final class _BottomButton extends StatefulWidget {
  /// Creates a new [_BottomButton] widget.
  ///
  /// Parameters:
  /// * [storyMedia] - Required story media item containing button information
  /// * [onBottomButtonTap] - Optional callback when button is tapped
  /// * [bottomButtonTitleBuilder] - Optional custom builder for button title
  const _BottomButton({
    required this.storyMedia,
    this.onBottomButtonTap,
    this.bottomButtonTitleBuilder,
  });

  /// The story media item containing button information.
  final StoryMedia storyMedia;

  /// Callback function when the button is tapped.
  final ValueSetter<StoryMedia>? onBottomButtonTap;

  /// Custom builder for the button title widget.
  final StoryMediaWidgetBuilder? bottomButtonTitleBuilder;

  @override
  State<_BottomButton> createState() => _BottomButtonState();
}

/// The state class for [_BottomButton].
///
/// Handles the button's bouncing arrow animation.
final class _BottomButtonState extends State<_BottomButton> with SingleTickerProviderStateMixin {
  /// Animation controller for the bouncing arrow animation.
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.storyMedia.isBottomButtonVisible) return const SizedBox.shrink();
    return InkWell(
      onTap: () => widget.onBottomButtonTap?.call(widget.storyMedia),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8) + const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -6 * _controller.value),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
            widget.bottomButtonTitleBuilder != null
                ? widget.bottomButtonTitleBuilder!(widget.storyMedia)
                : Text(
                    widget.storyMedia.bottomButtonTitle ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
          ],
        ),
      ),
    );
  }
}
