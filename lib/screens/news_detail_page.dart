import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:employee_cards/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/news_item.dart';
import '../services/news_api_service.dart';

class NewsDetailPage extends StatefulWidget {
  final int newsId;

  const NewsDetailPage({super.key, required this.newsId});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final NewsApiService _apiService = NewsApiService();

  NewsItem? news;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final loadedNews = await _apiService.getNewsDetail(
        newsId: widget.newsId,
      );

      if (!mounted) return;

      setState(() {
        news = loadedNews;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          l10n.newsDetails,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 40,
              ),

              const SizedBox(height: 12),

              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 16),

              FilledButton(
                onPressed: _loadNews,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final loadedNews = news;

    if (loadedNews == null) {
      return const SizedBox.shrink();
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (loadedNews.mainImage.isNotEmpty)
          Image.network(
            loadedNews.mainImage,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            cacheHeight: 440,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 220,
                color: AppColors.primaryLight,
                child: const Icon(
                  Icons.newspaper_outlined,
                  color: AppColors.primary,
                  size: 48,
                ),
              );
            },
          ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loadedNews.title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),

              if (loadedNews.createdAt != null) ...[
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      DateFormat(
                        'yyyy/MM/dd - HH:mm',
                      ).format(loadedNews.createdAt!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 18),

              const Divider(color: AppColors.border),

              const SizedBox(height: 18),

              for (final paragraph in loadedNews.contentParagraphs) ...[
                Text(
                  paragraph,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.8,
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
