import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flutter/material.dart';

class BaseElementButton extends StatelessWidget {
  final String name;
  final Icon icon;
  final VoidCallback onTap;
  final double borderRadius;
  final Color color;
  final EdgeInsets padding;

  const BaseElementButton({
    super.key,
    required this.name,
    required this.icon,
    this.color = Colors.transparent,
    this.padding = const EdgeInsets.all(4),
    required this.onTap,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final fill = color == Colors.transparent ? AppColors.cardColor.withValues(alpha: 0.45) : color;
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.white.withValues(alpha: 0.04),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.95)),
          ),
          child: SizedBox(
            height: 82,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(color: AppColors.primary.withValues(alpha: 0.95), size: 26),
                  child: icon,
                ),
                const SizedBox(height: 8),
                TextAtom(
                  text: name,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white.withValues(alpha: 0.92),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
