import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ShimmerChildComponent extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color color;
  const ShimmerChildComponent({
    super.key,
    this.width = 100,
    this.height = 40,
    this.radius = 12,
    this.color = AppColors.layoutBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
