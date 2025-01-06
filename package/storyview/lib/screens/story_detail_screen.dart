import 'dart:async';
import 'package:flutter/material.dart';
import 'package:storyview/screens/cube_page_view_builder.dart';
import 'package:storyview/screens/story.dart';
import 'package:video_player/video_player.dart';

final class StoryDetailScreen extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const StoryDetailScreen({
    super.key,
    required this.stories,
    required this.initialIndex,
  });

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen>
    with SingleTickerProviderStateMixin {
  late int currentStoryIndex;
  late int currentMediaIndex;
  late PageController pageController;
  Timer? timer;
  double progressValue = 0.0;
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    currentStoryIndex = widget.initialIndex;
    currentMediaIndex = 0;
    pageController = PageController(initialPage: currentStoryIndex);
    _setupCurrentMedia();
  }

  void _setupCurrentMedia() {
    final story = widget.stories[currentStoryIndex];

    if (currentMediaIndex < 0 || currentMediaIndex >= story.urls.length) {
      currentMediaIndex = 0;
    }

    final media = story.urls[currentMediaIndex];

    timer?.cancel();
    if (videoController != null) {
      videoController!.pause();
      videoController!.dispose();
      videoController = null;
    }

    if (media.isVideo) {
      if (media.url.isEmpty) return;

      videoController = VideoPlayerController.network(media.url)
        ..initialize().then((_) {
          setState(() {});
          videoController!.play();
          timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
            if (!mounted) return;

            setState(() {
              progressValue = videoController!.value.position.inMilliseconds /
                  videoController!.value.duration.inMilliseconds;
              if (progressValue >= 1.0) {
                nextMediaOrStory();
              }
            });
          });
        });
    } else {
      progressValue = 0.0;
      startImageProgressBar();
    }
  }

  void startImageProgressBar() {
    const duration = 5;
    int elapsedTime = 0;
    timer = Timer.periodic(const Duration(milliseconds: 50), (Timer t) {
      if (!mounted) return;

      setState(() {
        elapsedTime += 50;
        progressValue = elapsedTime / (duration * 1000);

        if (progressValue >= 1.0) {
          nextMediaOrStory();
        }
      });
    });
  }

  void nextMediaOrStory() {
    final story = widget.stories[currentStoryIndex];

    if (currentMediaIndex < story.urls.length - 1) {
      setState(() {
        currentMediaIndex++;
        progressValue = 0.0;
        _setupCurrentMedia();
      });
    } else if (currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        currentStoryIndex++;
        currentMediaIndex = 0;
        progressValue = 0.0;
        _setupCurrentMedia();
      });
    } else {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }


  void previousMediaOrStory() {
    if (currentMediaIndex > 0) {
      setState(() {
        currentMediaIndex--;
        progressValue = 0.0;
        _setupCurrentMedia();
      });
    } else if (currentStoryIndex > 0) {
      setState(() {
        currentStoryIndex--;
        currentMediaIndex = widget.stories[currentStoryIndex].urls.length - 1;
        progressValue = 0.0;
        _setupCurrentMedia();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[currentStoryIndex];
    final media = story.urls[currentMediaIndex];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
              // Yukarıdan aşağı çekme hareketi
              Navigator.of(context).pop();
            }
          },
          onTapUp: (details) {
            final width = MediaQuery.of(context).size.width;
            final dx = details.localPosition.dx;

            if (dx > width / 2) {
              if (currentStoryIndex == widget.stories.length - 1) {
                // Son story'de sağa kaydırma hareketi
                Navigator.of(context).pop();
              } else {
                nextMediaOrStory();
              }
            } else {
              previousMediaOrStory();
            }
          },
          child: Stack(
            children: [
              CubePageView.builder(
                itemCount: widget.stories.length,
                itemBuilder: (context, index, notifier) {
                  return CubeWidget(
                    index: index,
                    pageNotifier: notifier,
                    child: media.isVideo && videoController != null
                        ? Center(
                      child: videoController!.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        child: VideoPlayer(videoController!),
                      )
                          : const CircularProgressIndicator(),
                    )
                        : Image.network(
                      media.url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  );
                },
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStoryIndex = index;
                    currentMediaIndex = 0;
                    progressValue = 0.0;
                    _setupCurrentMedia();
                  });
                },
                children: [],
              ),
              // Progress bar at the top
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: List.generate(
                    story.urls.length,
                        (index) {
                      final isCurrent = index == currentMediaIndex;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: LinearProgressIndicator(
                            value: isCurrent
                                ? progressValue
                                : (index < currentMediaIndex ? 1.0 : 0.0),
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Close button at the top right
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
