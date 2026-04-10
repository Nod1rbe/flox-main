import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TappableComponent extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool disabled;
  final double borderRadius;
  final Color splashColor;
  final Color? highlightColor;
  final Color hoverColor;

  const TappableComponent({
    super.key,
    required this.onTap,
    required this.child,
    this.disabled = false,
    this.borderRadius = 16,
    this.splashColor = AppColors.defaultSplashColor,
    this.highlightColor = AppColors.transparent,
    this.hoverColor = AppColors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: splashColor,
          highlightColor: highlightColor,
          hoverColor: hoverColor,
          child: child,
        ),
      ),
    );
  }
}
