import 'package:unplug_story/model/story_media.dart';

/// A model class representing a story collection with multiple media items.
///
/// Each [Story] contains a list of media items ([StoryMedia]), a title, and a cover image.
/// This class is used to organize and display a collection of related story content
/// that can be viewed in sequence.
final class Story {
  /// Creates a new [Story] instance.
  ///
  /// All parameters are required:
  /// * [mediaList] - List of media items to be displayed in the story
  /// * [title] - Title of the story collection
  /// * [coverImageUrl] - URL of the cover image shown in story preview
  const Story({
    required this.mediaList,
    required this.title,
    required this.coverImageUrl,
  });

  /// List of media items that make up the story.
  ///
  /// Each item in the list is a [StoryMedia] object that can represent
  /// either an image or a video.
  final List<StoryMedia> mediaList;

  /// The title of the story collection.
  ///
  /// This is displayed in the story preview and can be used for identification.
  final String title;

  /// URL of the cover image used in story previews.
  ///
  /// This image is displayed in the story list before the story is opened.
  final String coverImageUrl;

  /// Example story data for demonstration purposes.
  ///
  /// Contains sample stories with various media types including images and videos.
  static List<Story> exampleUrls = [
    Story(
      title: "John's Adventure",
      coverImageUrl: 'https://picsum.photos/800/1600?3',
      mediaList: [
        StoryMedia(
          storyUrl:
              'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
          bottomButtonTitle: 'Tap to see more',
          bottomButtonUrl: 'https://www.google.com',
          isBottomButtonVisible: true,
        ),
        StoryMedia(
          storyUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          isVideo: true,
        ),
        StoryMedia(
          storyUrl:
              'https://github-production-user-asset-6210df.s3.amazonaws.com/16617696/409130994-302dfb60-1cf2-42c4-bfee-1e50f5dafd77.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20250204%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250204T082848Z&X-Amz-Expires=300&X-Amz-Signature=69b01cf55725e5c21f7e3523ec3f7f1526b0f16a41af8c953e48a0ec49d8b331&X-Amz-SignedHeaders=host',
        ),
        StoryMedia(
          storyUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          isVideo: true,
        ),
      ],
    ),
    Story(
      title: "Emily's Trip",
      coverImageUrl: 'https://picsum.photos/800/1600?3',
      mediaList: [
        StoryMedia(storyUrl: 'https://picsum.photos/800/1600?2'),
        StoryMedia(storyUrl: 'https://picsum.photos/800/1600?3'),
        StoryMedia(
          storyUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          isVideo: true,
        ),
      ],
    ),
    Story(
      title: "Mike's Adventure",
      coverImageUrl: 'https://picsum.photos/800/1600?4',
      mediaList: [
        StoryMedia(storyUrl: 'https://picsum.photos/800/1600?4'),
      ],
    ),
    Story(
      title: "Anna's Day Out",
      coverImageUrl: 'https://picsum.photos/800/1600?5',
      mediaList: [
        StoryMedia(storyUrl: 'https://picsum.photos/800/1600?5'),
      ],
    ),
  ];
}
