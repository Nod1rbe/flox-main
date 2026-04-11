import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PageAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const PageAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 4),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.65),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.add_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
