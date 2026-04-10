import 'package:auto_route/annotations.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
    );
  }
}
