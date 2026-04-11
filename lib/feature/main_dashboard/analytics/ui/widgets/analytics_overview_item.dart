import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AnalyticsOverviewItem extends StatelessWidget {
  final String title;
  final String data;
  final SvgGenImage icon;
  final Color iconColor;

  const AnalyticsOverviewItem({
    super.key,
    required this.title,
    required this.data,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon.svg(
          height: 18,
          width: 18,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.subtitle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
