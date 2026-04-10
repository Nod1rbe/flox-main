import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
import 'package:flutter/material.dart';

class AuthWelcomingWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthWelcomingWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 32,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.subtitle,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).center,
    );
  }
}
