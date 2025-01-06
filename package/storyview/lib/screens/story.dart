class UrlItem {
  final String url;
  final bool isVideo;

  UrlItem({required this.url, required this.isVideo});
}

class Story {
  final List<UrlItem> urls;
  final String title;
  final String coverImageUrl;

  Story({
    required this.urls,
    required this.title,
    required this.coverImageUrl,
  });
}