import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BaseContainerComponent extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final double borderRadius;
  final BoxBorder? border;
  final EdgeInsets padding;
  final double? height;
  final double? width;
  final Color color;
  const BaseContainerComponent({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16,
    this.border,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.layoutBackground,
    this.height,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
