import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PageAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const PageAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 20,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
