import 'package:auto_route/auto_route.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/core/routes/auth_guard.dart';

import '../extensions/is_mobile_device.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard = AuthGuard();
  final DeviceGuard deviceGuard = DeviceGuard();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/',
          keepHistory: false,
          guards: [deviceGuard],
        ),

        AutoRoute(
          page: MainNavigationRoute.page,
          path: '/dashboard',
          guards: [authGuard, deviceGuard],
          children: [
            AutoRoute(
              page: MyFunnelsRoute.page,
              initial: true,
              path: 'my-funnels',
              guards: [authGuard, deviceGuard],
            ),
            AutoRoute(
              page: AnalyticsRoute.page,
              path: 'analytics',
              guards: [authGuard, deviceGuard],
            ),
            AutoRoute(
              page: BillingRoute.page,
              path: 'billing',
              guards: [authGuard, deviceGuard],
            ),
            AutoRoute(
              page: SettingsRoute.page,
              path: 'settings',
              guards: [authGuard, deviceGuard],
            ),
          ],
        ),

        AutoRoute(
          page: BuilderRoute.page,
          path: '/builder',
          guards: [authGuard, deviceGuard],
        ),

        AutoRoute(
          page: AuthenticationRoute.page,
          path: '/authentication',
          keepHistory: false,
          guards: [deviceGuard],
        ),
        AutoRoute(
          page: MobileBlockRoute.page,
          path: '/mobile-block',
        ),

        /// Test
        AutoRoute(page: ExperienceSRoute.page, guards: [authGuard, deviceGuard]),
        AutoRoute(page: ExperienceHRoute.page, guards: [authGuard, deviceGuard]),
        AutoRoute(page: ExperienceNRoute.page, guards: [authGuard, deviceGuard]),
      ];
}
