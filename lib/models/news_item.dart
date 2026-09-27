class NewsItem {
  final int id;
  final String title;
  final String summary;
  final String mainImage;
  final DateTime? createdAt;

  /// Full HTML body of the news article.
  /// Only populated when fetched from the news-details endpoint.
  final String? content;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.mainImage,
    required this.createdAt,
    this.content,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final phrases = (json['phrases'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    String phraseValue(String keyName) {
      for (final phrase in phrases) {
        if (phrase['key_name'] == keyName) {
          return phrase['value']?.toString() ?? '';
        }
      }
      return '';
    }

    final contentJson = json['content'];
    final contentHtml = contentJson is Map<String, dynamic>
        ? contentJson['value']?.toString()
        : null;

    return NewsItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: phraseValue('title'),
      summary: phraseValue('metaDesc'),
      mainImage: json['main_image']?.toString() ?? '',
      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? '',
      ),
      content: contentHtml,
    );
  }

  /// The article body with HTML tags stripped, split into paragraphs.
  List<String> get contentParagraphs {
    final html = content ?? '';

    if (html.isEmpty) return [];

    return html
        .split(RegExp(r'</p>|<br\s*/?>', caseSensitive: false))
        .map(
          (part) => part
              .replaceAll(RegExp(r'<[^>]*>'), '')
              .replaceAll('&nbsp;', ' ')
              .trim(),
        )
        .where((part) => part.isNotEmpty)
        .toList();
  }
}
