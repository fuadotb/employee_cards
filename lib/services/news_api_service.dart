import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/news_category.dart';
import '../models/news_item.dart';

class NewsFeed {
  final List<NewsCategory> categories;
  final List<NewsItem> news;

  NewsFeed({
    required this.categories,
    required this.news,
  });
}

class NewsApiService {
  static const String baseUrl = 'https://uqu.edu.sa/Api/v1/Cms';

  static const String uquAuth =
      '8c15a44f19053149b8f21ce6f355a143';

  Future<NewsFeed> getNews({
    int? categoryId,
    int page = 1,
  }) async {
    final path = categoryId != null
        ? '/NewsCats/$categoryId'
        : '/NewsCats';

    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: {'page': page.toString()},
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'x-uqu-auth': uquAuth,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load news: '
        '${response.statusCode}\n'
        '${response.body}',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (body['status'] != 'success') {
      throw Exception(
        'News API returned unsuccessful status\n'
        '${response.body}',
      );
    }

    final data = body['data'];

    if (data == null || data is! Map<String, dynamic>) {
      throw Exception(
        'Invalid news data\n${response.body}',
      );
    }

    final categories = (data['cats'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(NewsCategory.fromJson)
        .toList()
      ..sort((a, b) => a.ordering.compareTo(b.ordering));

    final newsBlock = data['news'];
    final newsListJson = newsBlock is Map<String, dynamic>
        ? (newsBlock['data'] as List<dynamic>? ?? [])
        : const <dynamic>[];

    final news = newsListJson
        .whereType<Map<String, dynamic>>()
        .map(NewsItem.fromJson)
        .toList();

    return NewsFeed(categories: categories, news: news);
  }

  Future<NewsItem> getNewsDetail({
    required int newsId,
  }) async {
    final uri = Uri.parse('$baseUrl/News/$newsId');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'x-uqu-auth': uquAuth,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load news details: '
        '${response.statusCode}\n'
        '${response.body}',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (body['status'] != 'success') {
      throw Exception(
        'News API returned unsuccessful status\n'
        '${response.body}',
      );
    }

    final data = body['data'];

    if (data == null || data is! Map<String, dynamic>) {
      throw Exception(
        'Invalid news data\n${response.body}',
      );
    }

    return NewsItem.fromJson(data);
  }
}
