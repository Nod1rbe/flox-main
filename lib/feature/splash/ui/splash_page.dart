import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/feature/splash/splash_bloc/splash_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashBloc _splashBloc;
  Timer? _fallbackTimer;

  @override
  void initState() {
    _splashBloc = getIt<SplashBloc>();
    _splashBloc.add(CheckAuthStatusEvent());
    _fallbackTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (context.router.current.name == SplashRoute.name) {
        context.router.replaceAll([const AuthenticationRoute()]);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _splashBloc,
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          log(state.authStatus.toString());
          if (state.authStatus.isAuth) {
            _fallbackTimer?.cancel();
            context.router.replaceAll([const AuthenticationRoute()]);
          } else if (state.authStatus.isDashboard) {
            _fallbackTimer?.cancel();
            context.router.replaceAll([const MainNavigationRoute()]);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageBackground,
            body: Center(
              child: CupertinoActivityIndicator(
                color: AppColors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
