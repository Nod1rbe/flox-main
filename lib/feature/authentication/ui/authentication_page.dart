import 'package:auto_route/annotations.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/feature/authentication/bloc/authentication_bloc.dart';
import 'package:flox/feature/authentication/ui/login_form.dart';
import 'package:flox/feature/authentication/ui/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthenticationBloc>(),
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageBackground,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final isLogin = child.key == const ValueKey('Login');
                final slideBeginOffset = isLogin ? const Offset(0.0, -0.1) : const Offset(0.0, 0.1);

                final inAnimation = Tween<Offset>(
                  begin: slideBeginOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

                final fadeAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                );

                return SlideTransition(
                  position: inAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: child,
                  ),
                );
              },
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: state.isLoginForm
                  ? LoginForm(key: const ValueKey('Login'))
                  : RegisterForm(key: const ValueKey('Register')),
            ),
          );
        },
      ),
    );
  }
}
