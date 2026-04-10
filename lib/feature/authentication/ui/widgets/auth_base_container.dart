import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
import 'package:flutter/material.dart';

class AuthBaseContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;
  const AuthBaseContainer({
    super.key,
    required this.title,
    required this.child,
    this.height = 480,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
        maxWidth: 420,
        minHeight: height,
        minWidth: 400,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.layoutBackground,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ).center,
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    ).center;
  }
}
