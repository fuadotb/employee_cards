
import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:employee_cards/models/news_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewsCard extends StatelessWidget {
  final NewsItem news;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.news,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = news.createdAt;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // Image
              // ─────────────────────────────
              Stack(
                children: [
                  SizedBox(
                    height: 165,
                    width: double.infinity,
                    child: news.mainImage.isNotEmpty
                        ? Image.network(
                            news.mainImage,
                            fit: BoxFit.cover,
                            cacheWidth: 700,
                            errorBuilder: (context, error, stackTrace) {
                              return _placeholderImage();
                            },
                          )
                        : _placeholderImage(),
                  ),

                  // Subtle image gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.45, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.35),
                          ],
                        ),
                      ),
                    ),
                  ),

                  

                  // Date
                  if (createdAt != null)
                    PositionedDirectional(
                      bottom: 12,
                      start: 12,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('yyyy/MM/dd').format(createdAt),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // ─────────────────────────────
              // Content
              // ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        news.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Arrow
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(
                          alpha: 0.25,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: AppColors.primaryLight.withValues(alpha: 0.2),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 34,
        color: AppColors.primary,
      ),
    );
  }
}
