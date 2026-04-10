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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.white),
        ),
        child: SizedBox(
          height: 80,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 8),
              TextAtom(text: name),
            ],
          ),
        ),
      ),
    );
  }
}
