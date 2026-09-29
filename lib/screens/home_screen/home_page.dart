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

      final feed = await _newsApiService.getNews(categoryId: categoryId);

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          l10n.home,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () => _loadNews(categoryId: selectedCategoryId),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          children: [
            Text(
              l10n.news,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 36,
            ),

            const SizedBox(height: 10),

            Text(
              l10n.failedToLoadNews,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.error, fontSize: 13),
            ),

            const SizedBox(height: 14),

            FilledButton(
              onPressed: () => _loadNews(categoryId: selectedCategoryId),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
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
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
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
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
