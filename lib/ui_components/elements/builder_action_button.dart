import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuilderActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final Widget? icon;
  final bool loading;
  final double height;
  final double width;

  const BuilderActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isPrimary = false,
    this.loading = false,
    this.height = 32,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary ? AppColors.primary : AppColors.defaultButtonBackground;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      elevation: isPrimary ? 2 : 0,
      shadowColor: isPrimary ? AppColors.primary.withValues(alpha: 0.45) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white.withValues(alpha: 0.12),
        highlightColor: Colors.white.withValues(alpha: 0.06),
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: loading
              ? Center(
                  child: CupertinoActivityIndicator(
                  color: AppColors.white,
                  radius: height / 4,
                ))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: 5),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
