import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:employee_cards/l10n/app_localizations.dart';
import 'package:employee_cards/models/news_category.dart';
import 'package:employee_cards/models/news_item.dart';
import 'package:employee_cards/routes/route_key.dart';
import 'package:employee_cards/services/news_api_service.dart';
import 'package:employee_cards/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsApiService _newsApiService = NewsApiService();

  List<NewsCategory> categories = [];
  List<NewsItem> news = [];
  int? selectedCategoryId;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews({int? categoryId}) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        selectedCategoryId = categoryId;
      });

      final feed = await _newsApiService.getNews(
        categoryId: categoryId,
      );

      if (!mounted) return;

      setState(() {
        news = feed.news;
        if (categories.isEmpty) categories = feed.categories;
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
          l10n.home,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => _loadNews(categoryId: selectedCategoryId),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          children: [
            Text(
              l10n.news,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            if (categories.isNotEmpty) _buildCategories(l10n),

            const SizedBox(height: 16),

            _buildContent(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(AppLocalizations l10n) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _CategoryChip(
            label: l10n.allNews,
            selected: selectedCategoryId == null,
            onTap: () => _loadNews(),
          ),

          for (final category in categories) ...[
            const SizedBox(width: 8),

            _CategoryChip(
              label: category.name,
              selected: selectedCategoryId == category.id,
              onTap: () => _loadNews(categoryId: category.id),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 36,
            ),

            const SizedBox(height: 10),

            Text(
              l10n.failedToLoadNews,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 14),

            FilledButton(
              onPressed: () => _loadNews(categoryId: selectedCategoryId),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (news.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            l10n.noNews,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final item in news) ...[
          NewsCard(
            news: item,
            onTap: () {
              context.push(RouteKey.newsDetailPath(item.id));
            },
          ),

          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
