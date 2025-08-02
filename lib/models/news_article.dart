class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final String sourceUrl;
  final String source;
  final DateTime publishedAt;
  final List<String> tags;
  final String category;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.sourceUrl,
    required this.source,
    required this.publishedAt,
    required this.tags,
    required this.category,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      source: json['source'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'imageUrl': imageUrl,
      'sourceUrl': sourceUrl,
      'source': source,
      'publishedAt': publishedAt.toIso8601String(),
      'tags': tags,
      'category': category,
    };
  }
}
