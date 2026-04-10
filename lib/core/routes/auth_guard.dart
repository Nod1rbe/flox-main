import 'package:auto_route/auto_route.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGuard extends AutoRouteGuard {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    _client.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.signedOut) {
        router.replaceAll([const AuthenticationRoute()]);
      }
    });

    final session = _client.auth.currentSession;
    if (session != null) {
      resolver.next(true);
    } else {
      router.replaceAll([const AuthenticationRoute()]);
    }
  }
}
