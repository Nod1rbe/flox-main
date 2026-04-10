import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/feature/authentication/bloc/authentication_bloc.dart';
import 'package:flox/ui_components/components/atoms/button_atom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleAuthButton extends StatelessWidget {
  final String title;

  const GoogleAuthButton({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (o, n) => o.googleSignInStatus != n.googleSignInStatus,
      listener: (context, state) {
        if (state.googleSignInStatus.isFailure) {
          context.router.replaceAll([const AuthenticationRoute()]);
        }
        if (state.googleSignInStatus.isSuccess) {
          context.router.replaceAll([const MainNavigationRoute()]);
        }
      },
      buildWhen: (o, n) => o.googleSignInStatus != n.googleSignInStatus,
      builder: (context, state) {
        return ButtonAtom(
          loading: state.googleSignInStatus.isLoading,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.transparent,
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          onTap: () {
            context.read<AuthenticationBloc>().add(SignInWithGoogleEvent());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Assets.icons.googleLogo.svg(width: 20, height: 20),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        );
      },
    );
  }
}
