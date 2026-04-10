import 'dart:developer';

import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/authentication/bloc/authentication_bloc.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthTogglePrompt extends StatelessWidget {
  final String text;
  final String buttonText;
  final bool shouldSwitchToLogin;
  const AuthTogglePrompt({
    super.key,
    required this.text,
    required this.buttonText,
    required this.shouldSwitchToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(color: AppColors.white),
        ),
        TappableComponent(
          onTap: () {
            log(shouldSwitchToLogin.toString());
            context.read<AuthenticationBloc>().add(ChangeFormEvent(shouldSwitchToLogin));
          },
          borderRadius: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              buttonText,
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
