/// A model class representing a single media item within a story.
///
/// This class holds information about a media item (image or video) and its
/// associated interactive elements like bottom buttons. Each [StoryMedia] instance
/// represents one "page" in a story sequence.
final class StoryMedia {
  /// Creates a new [StoryMedia] instance.
  ///
  /// Parameters:
  /// * [storyUrl] - Required URL of the media content (image or video)
  /// * [isVideo] - Whether the media is a video (defaults to false)
  /// * [bottomButtonTitle] - Optional title for the bottom action button
  /// * [bottomButtonUrl] - Optional URL for the bottom button action
  /// * [isBottomButtonVisible] - Whether to show the bottom button (defaults to false)
  const StoryMedia({
    required this.storyUrl,
    this.isVideo = false,
    this.bottomButtonTitle,
    this.bottomButtonUrl,
    this.isBottomButtonVisible = false,
  });

  /// The URL of the media content (image or video).
  final String storyUrl;

  /// Indicates whether the media content is a video.
  ///
  /// If true, the content will be played as a video; if false, it will be displayed as an image.
  final bool isVideo;

  /// The title text to display on the bottom action button.
  ///
  /// This is only relevant if [isBottomButtonVisible] is true.
  final String? bottomButtonTitle;

  /// The URL to navigate to when the bottom button is tapped.
  ///
  /// This is only relevant if [isBottomButtonVisible] is true.
  final String? bottomButtonUrl;

  /// Controls the visibility of the bottom action button.
  ///
  /// When true, displays a button at the bottom of the story with [bottomButtonTitle]
  /// that links to [bottomButtonUrl] when tapped.
  final bool isBottomButtonVisible;
}
