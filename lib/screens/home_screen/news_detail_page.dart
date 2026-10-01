import 'package:employee_cards/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/news_item.dart';
import '../../services/news_api_service.dart';

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

      final loadedNews = await _apiService.getNewsDetail(newsId: widget.newsId);

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
          strokeWidth: 2.5,
        ),
      );
    }

    if (errorMessage != null) {
      return _buildError(l10n);
    }

    final loadedNews = news;

    if (loadedNews == null) {
      return const SizedBox.shrink();
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ─────────────────────────────
        // Hero Image
        // ─────────────────────────────
        SliverAppBar(
          expandedHeight: 195,
          pinned: true,
          elevation: 0,
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: _circleButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: _buildHeroImage(loadedNews),
          ),
        ),

        // ─────────────────────────────
        // Content
        // ─────────────────────────────
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    loadedNews.title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      letterSpacing: -0.2,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Accent + Date
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 3,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            width: 35,
                            height: 3,
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      if (loadedNews.createdAt != null)
                        Row(
                          children: [
                             Icon(
                              Icons.schedule_rounded,
                              size: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat(
                                'yyyy/MM/dd',
                              ).format(loadedNews.createdAt!),
                              style:  TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Article
                  for (final paragraph in loadedNews.contentParagraphs) ...[
                    Text(
                      paragraph,
                      textAlign: TextAlign.start,
                      style:  TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.9,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(NewsItem loadedNews) {
  
    if (loadedNews.mainImage.isEmpty) {
      return _placeholderImage();
    }

    return Image.network(
      loadedNews.mainImage,
      fit: BoxFit.cover,
      cacheHeight: 420,
      errorBuilder: (context, error, stackTrace) {
        return _placeholderImage();
      },
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
        final colorScheme = Theme.of(context).colorScheme;
    return Material(
        color: colorScheme.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Icon(icon, size: 18,     color: colorScheme.onSurface,),
      ),
    );
  }

  Widget _placeholderImage() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
          color: colorScheme.primary.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child:  Icon(
        Icons.newspaper_outlined,
        color: colorScheme.primary,
        size: 44,
      ),
    );
  }

  Widget _buildError(AppLocalizations l10n) {
      final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child:  Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style:  TextStyle(
                fontSize: 13,
                height: 1.5,
              color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: _loadNews,
              style: FilledButton.styleFrom(
                 backgroundColor: colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
