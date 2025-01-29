import 'package:flutter/material.dart';
import 'package:unplug_story/model/story.dart';
import 'package:unplug_story/model/story_media.dart';
import 'package:unplug_story/widget/story_detail/story_detail_widget.dart';
import 'package:video_player/video_player.dart';

mixin StoryDetailMixin on State<StoryDetailWidget>, SingleTickerProviderStateMixin<StoryDetailWidget> {
  late final PageController _pageController;
  late final AnimationController _progressController;
  VideoPlayerController? _videoPlayerController;
  Offset? _dragStartPosition;
  double currentPage = 0.0;
  int currentStoryMediaIndex = 0;

  PageController get pageController => _pageController;
  AnimationController get progressController => _progressController;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  Story get currentStory => widget.stories[currentPage.toInt()];
  List<StoryMedia> get currentStoryMediaList => currentStory.mediaList;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialIndex.toDouble();
    _pageController = PageController(
      initialPage: widget.initialIndex,
    );
    if (currentStoryMediaList[currentStoryMediaIndex].isVideo) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(currentStoryMediaList[currentStoryMediaIndex].url),
      );
    }
    _progressController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..addListener(
        () async {
          if (_progressController.status != AnimationStatus.completed) return;
          tapNextPage();
        },
      );
    _pageController.addListener(() async {
      final page = _pageController.page;
      if (page == null) return;
      currentPage = page;
      currentStoryMediaIndex = 0;
      setState(() {});
      await initialPage();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialPage();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> initialPage() async {
    _progressController.reset();
    _videoPlayerController?.dispose();
    if (currentStoryMediaList[currentStoryMediaIndex].isVideo) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(currentStoryMediaList[currentStoryMediaIndex].url),
      );
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.play();
      _progressController.duration = _videoPlayerController!.value.duration;
      _progressController.forward();
      return;
    }
    _progressController.duration = const Duration(milliseconds: 1500);
    _progressController.forward();
  }

  void handleDragStart(DragStartDetails details) {
    _dragStartPosition = details.globalPosition;
  }

  void handleDragUpdate(DragUpdateDetails details) {
    if (_dragStartPosition == null) return;

    final delta = details.globalPosition - _dragStartPosition!;
    final isVerticalDrag = delta.dy.abs() > delta.dx.abs();

    // Handle vertical drag
    if (isVerticalDrag && delta.dy > 50) {
      Navigator.of(context).pop();
      return;
    }
  }

  void handleDragEnd(DragEndDetails details) {
    _dragStartPosition = null;
  }

  void handleTapUp(TapUpDetails details) {
    final tapPosition = details.globalPosition;
    final tapX = tapPosition.dx;
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (tapX < screenWidth / 2) {
      tapPreviousPage();
    } else {
      tapNextPage();
    }
  }

  Future<void> tapNextPage() async {
    if (currentStoryMediaIndex < currentStoryMediaList.length - 1) {
      currentStoryMediaIndex++;
      setState(() {});
      await initialPage();
      return;
    }
    if (currentPage >= widget.stories.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    _pageController.nextPage(duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  Future<void> tapPreviousPage() async {
    if (currentStoryMediaIndex > 0) {
      currentStoryMediaIndex--;
      setState(() {});
      await initialPage();
      return;
    }
    _pageController.previousPage(duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }
}
