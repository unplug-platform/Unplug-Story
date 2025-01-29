import 'package:unplug_story/model/story_media.dart';

final class Story {
  const Story({
    required this.mediaList,
    required this.title,
    required this.coverImageUrl,
  });

  final List<StoryMedia> mediaList;
  final String title;
  final String coverImageUrl;

  static List<Story> exampleUrls = [
    Story(
      title: "John's Adventure",
      coverImageUrl: 'https://picsum.photos/800/1600?3',
      mediaList: [
        StoryMedia(url: 'https://picsum.photos/800/1600?1', isVideo: false),
        StoryMedia(
          url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          isVideo: true,
        ),
        StoryMedia(url: 'https://picsum.photos/800/1600?2', isVideo: false),
        StoryMedia(
          url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          isVideo: true,
        ),
      ],
    ),
    Story(
      title: "Emily's Trip",
      coverImageUrl: 'https://picsum.photos/800/1600?3',
      mediaList: [
        StoryMedia(url: 'https://picsum.photos/800/1600?2', isVideo: false),
        StoryMedia(url: 'https://picsum.photos/800/1600?3', isVideo: false),
        StoryMedia(
          url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          isVideo: true,
        ),
      ],
    ),
    Story(
      title: "Mike's Adventure",
      coverImageUrl: 'https://picsum.photos/800/1600?4',
      mediaList: [
        StoryMedia(url: 'https://picsum.photos/800/1600?4', isVideo: false),
      ],
    ),
    Story(
      title: "Anna's Day Out",
      coverImageUrl: 'https://picsum.photos/800/1600?5',
      mediaList: [
        StoryMedia(url: 'https://picsum.photos/800/1600?5', isVideo: false),
      ],
    ),
  ];
}
