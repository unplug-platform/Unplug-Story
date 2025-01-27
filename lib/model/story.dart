import 'package:unplug_story/model/story_url.dart';

final class Story {
  const Story({
    required this.urls,
    required this.title,
    required this.coverImageUrl,
  });

  final List<StoryUrl> urls;
  final String title;
  final String coverImageUrl;

  static List<Story> exampleUrls = [
    Story(
      title: "John's Adventure",
      coverImageUrl: 'https://picsum.photos/800/1600?3',
      urls: [
        StoryUrl(url: 'https://picsum.photos/800/1600?1', isVideo: false),
        StoryUrl(
          url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          isVideo: true,
        ),
        StoryUrl(url: 'https://picsum.photos/800/1600?2', isVideo: false),
        StoryUrl(
          url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          isVideo: true,
        ),
      ],
    ),
    Story(
      title: "Emily's Trip",
      coverImageUrl: 'https://picsum.photos/800/1600?3',
      urls: [
        StoryUrl(url: 'https://picsum.photos/800/1600?2', isVideo: false),
        StoryUrl(url: 'https://picsum.photos/800/1600?3', isVideo: false),
        StoryUrl(
          url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          isVideo: true,
        ),
      ],
    ),
    Story(
      title: "Mike's Adventure",
      coverImageUrl: 'https://picsum.photos/800/1600?4',
      urls: [
        StoryUrl(url: 'https://picsum.photos/800/1600?4', isVideo: false),
      ],
    ),
    Story(
      title: "Anna's Day Out",
      coverImageUrl: 'https://picsum.photos/800/1600?5',
      urls: [
        StoryUrl(url: 'https://picsum.photos/800/1600?5', isVideo: false),
      ],
    ),
  ];
}
