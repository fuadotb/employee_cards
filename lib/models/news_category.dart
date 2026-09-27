class NewsCategory {
  final int id;
  final String name;
  final int ordering;

  NewsCategory({
    required this.id,
    required this.name,
    required this.ordering,
  });

  factory NewsCategory.fromJson(Map<String, dynamic> json) {
    return NewsCategory(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['value']?.toString() ?? '',
      ordering: int.tryParse(json['ordering']?.toString() ?? '') ?? 0,
    );
  }
}
