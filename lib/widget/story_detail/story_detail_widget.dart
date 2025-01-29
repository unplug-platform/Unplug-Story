import 'dart:math' show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unplug_story/model/story.dart';
import 'package:unplug_story/widget/story_detail/story_detail_mixin.dart';
import 'package:video_player/video_player.dart';

final class StoryDetailWidget extends StatefulWidget {
  const StoryDetailWidget({super.key, required this.stories, required this.initialIndex});
  final List<Story> stories;
  final int initialIndex;

  @override
  State<StoryDetailWidget> createState() => _StoryDetailWidgetState();
}

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
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                itemCount: widget.stories.length,
                pageSnapping: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final story = widget.stories[index];
                  final urlList = story.mediaList;
                  final relativePosition = index - currentPage;
                  final currentStoryMedia = currentStoryMediaList[currentStoryMediaIndex];

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateY(relativePosition * -pi / 2),
                    alignment: relativePosition >= 0 ? Alignment.centerLeft : Alignment.centerRight,
                    child: Stack(
                      children: [
                        currentStoryMedia.isVideo
                            ? videoPlayerController == null
                                ? const Center(child: CircularProgressIndicator())
                                : Center(
                                    child: AspectRatio(
                                      aspectRatio: videoPlayerController!.value.aspectRatio,
                                      child: VideoPlayer(videoPlayerController!),
                                    ),
                                  )
                            : CachedNetworkImage(
                                imageUrl: currentStoryMedia.url,
                                fit: BoxFit.cover,
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height,
                              ),
                        Positioned(
                          top: 8,
                          left: 8,
                          right: 8,
                          child: Row(
                            spacing: 4,
                            children: List.generate(
                              urlList.length,
                              (index) {
                                return Expanded(
                                  child: AnimatedBuilder(
                                    animation: progressController,
                                    builder: (context, child) {
                                      return LinearProgressIndicator(
                                        value: currentStoryMediaIndex == index
                                            ? progressController.value
                                            : currentStoryMediaIndex > index
                                                ? 1
                                                : 0,
                                        color: Colors.green,
                                        backgroundColor: Colors.red,
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
                          child: _StoryInfo(story: story),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _StoryInfo extends StatelessWidget {
  const _StoryInfo({
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(
            story.coverImageUrl,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          story.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}
