import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HorizontalDividerComponent extends StatelessWidget {
  final double height;
  final double thickness;
  final Color color;
  final EdgeInsets margin;
  const HorizontalDividerComponent({
    super.key,
    this.height = 50,
    this.color = AppColors.dividerColor,
    this.thickness = 1,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: thickness,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color,
      ),
    );
  }
}
