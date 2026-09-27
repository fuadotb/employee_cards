import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/news_item.dart';

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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(18),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: news.mainImage.isNotEmpty
                    ? Image.network(
                        news.mainImage,
                        fit: BoxFit.cover,
                        cacheWidth: 200,
                        cacheHeight: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return _placeholderImage();
                        },
                      )
                    : _placeholderImage(),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (createdAt != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            DateFormat('yyyy/MM/dd').format(createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: AppColors.primaryLight,
      child: const Icon(
        Icons.newspaper_outlined,
        color: AppColors.primary,
        size: 32,
      ),
    );
  }
}
