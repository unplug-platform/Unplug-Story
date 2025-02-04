import 'package:flutter/material.dart';
import 'package:unplug_story/model/story.dart';
import 'package:unplug_story/model/story_media.dart';
import 'package:unplug_story/widget/story_detail/story_detail_widget.dart';
import 'package:video_player/video_player.dart';

/// A mixin that provides story detail functionality for [StoryDetailWidget].
///
/// This mixin handles all the core functionality of the story detail view including:
/// * Story navigation (next/previous)
/// * Progress tracking
/// * Video playback
/// * Gesture handling (tap, drag, long press)
/// * State management
///
/// It requires the [SingleTickerProviderStateMixin] to manage animations.
mixin StoryDetailMixin on State<StoryDetailWidget>, SingleTickerProviderStateMixin<StoryDetailWidget> {
  /// Controller for horizontal page navigation between stories.
  late final PageController _pageController;

  /// Controller for the progress indicator animation.
  late final AnimationController _progressController;

  /// Controller for video playback when story media is a video.
  VideoPlayerController? _videoPlayerController;

  /// Starting position of a drag gesture.
  Offset? _dragStartPosition;

  /// Current page position, can be fractional during page transitions.
  double currentPage = 0.0;

  /// Index of the currently displayed story.
  int currentStoryIndex = 0;

  /// Flag indicating whether a page transition is in progress.
  bool isPageChanging = false;

  /// Map storing the current media index for each story.
  final Map<int, int> storyMediaIndices = {};

  /// Duration to display each image story media (in milliseconds).
  final int storyImageDurationMs = 3000;

  /// Duration of the page transition animation (in milliseconds).
  final int changePageDurationMs = 800;

  /// Gets the current media index for the current story.
  int get currentStoryMediaIndex => storyMediaIndices[currentStoryIndex] ?? 0;

  /// The page controller for story navigation.
  PageController get pageController => _pageController;

  /// The progress indicator animation controller.
  AnimationController get progressController => _progressController;

  /// The video player controller for video story media.
  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  /// The currently displayed story.
  Story get currentStory => widget.stories[currentStoryIndex];

  /// List of media items in the current story.
  List<StoryMedia> get currentStoryMediaList => currentStory.mediaList;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialIndex.toDouble();
    currentStoryIndex = widget.initialIndex;
    storyMediaIndices[currentStoryIndex] = 0;
    _pageController = PageController(
      initialPage: widget.initialIndex,
    );
    if (currentStoryMediaList[currentStoryMediaIndex].isVideo) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(currentStoryMediaList[currentStoryMediaIndex].storyUrl),
      );
    }

    _progressController = AnimationController(vsync: this, duration: Duration(milliseconds: storyImageDurationMs))
      ..addListener(
        () async {
          if (_progressController.status != AnimationStatus.completed) return;
          tapNextPage();
        },
      );

    _pageController.addListener(() async {
      final page = _pageController.page;
      if (page == null) return;
      isPageChanging = page % 1 != 0;
      currentPage = page;
      setState(() {});
      if (isPageChanging) {
        _animationStop();
        return;
      } else {
        _animationForward();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialPage();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _disposeVideoPlayer();
    super.dispose();
  }

  /// Handles story changes when navigating between stories.
  ///
  /// Resets progress and initializes video player if needed.
  Future<void> onChanged(int value) async {
    _disposeVideoPlayer();
    currentStoryIndex = value;
    await initialPage();
  }

  /// Initializes the current page, setting up progress tracking and video playback.
  Future<void> initialPage() async {
    _progressController.reset();
    _disposeVideoPlayer();

    if (currentStoryMediaList[currentStoryMediaIndex].isVideo) {
      try {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(currentStoryMediaList[currentStoryMediaIndex].storyUrl),
        );
        await _videoPlayerController!.initialize();
        if (mounted) {
          setState(() {});
          await _videoPlayerController!.play();
          _progressController.duration = _videoPlayerController!.value.duration;
          _progressController.forward();
        }
      } catch (e) {
        print('Error initializing video player: $e');
        _disposeVideoPlayer();
      }
      return;
    }
    _progressController.duration = Duration(milliseconds: storyImageDurationMs);
    _progressController.forward();
  }

  /// Handles the start of a drag gesture.
  void handleDragStart(DragStartDetails details) {
    _dragStartPosition = details.globalPosition;
  }

  /// Handles drag updates, including vertical dismissal gesture.
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

  /// Handles the end of a drag gesture.
  void handleDragEnd(DragEndDetails details) {
    _dragStartPosition = null;
  }

  /// Handles tap gestures for navigation.
  ///
  /// Left side taps go to previous media/story, right side taps go to next.
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

  /// Navigates to the next media item or story.
  ///
  /// If at the end of current story's media, moves to next story.
  /// If at the last story, closes the story view.
  Future<void> tapNextPage() async {
    if (currentStoryMediaIndex < currentStoryMediaList.length - 1) {
      storyMediaIndices[currentStoryIndex] = currentStoryMediaIndex + 1;
      setState(() {});
      await initialPage();
      return;
    }
    if (currentPage >= widget.stories.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    _pageController.nextPage(duration: Duration(milliseconds: changePageDurationMs), curve: Curves.easeInOut);
  }

  /// Navigates to the previous media item or story.
  ///
  /// If at the start of current story's media, moves to previous story.
  Future<void> tapPreviousPage() async {
    if (currentStoryMediaIndex > 0) {
      storyMediaIndices[currentStoryIndex] = currentStoryMediaIndex - 1;
      setState(() {});
      await initialPage();
      return;
    }
    _pageController.previousPage(duration: Duration(milliseconds: changePageDurationMs), curve: Curves.easeInOut);
  }

  /// Handles the start of a long press gesture.
  ///
  /// Pauses progress and video playback.
  void handleLongPressStart(LongPressStartDetails details) {
    _animationStop();
  }

  /// Handles the end of a long press gesture.
  ///
  /// Resumes progress and video playback.
  void handleLongPressEnd(LongPressEndDetails details) {
    _animationForward();
  }

  /// Stops progress animation and video playback.
  void _animationStop() {
    _progressController.stop();
    if (currentStoryMediaList[currentStoryMediaIndex].isVideo) {
      _videoPlayerController!.pause();
    }
  }

  /// Resumes progress animation and video playback.
  void _animationForward() {
    _progressController.forward();
    if (currentStoryMediaList[currentStoryMediaIndex].isVideo) {
      _videoPlayerController!.play();
    }
  }

  /// Properly disposes of the video player controller.
  void _disposeVideoPlayer() {
    if (_videoPlayerController == null) return;
    _videoPlayerController!.pause();
    _videoPlayerController!.dispose();
    _videoPlayerController = null;
  }
}
