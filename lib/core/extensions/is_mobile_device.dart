import 'package:auto_route/auto_route.dart';
import 'package:web/helpers.dart' as html;

import '../routes/app_router.gr.dart';

bool isMobileDevice() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('iphone') ||
      userAgent.contains('android') ||
      userAgent.contains('ipad') ||
      userAgent.contains('mobile');
}

class DeviceGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isMobileDevice()) {
      router.replace(const MobileBlockRoute());
    } else {
      resolver.next(true);
    }
  }
}
