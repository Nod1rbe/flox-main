import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flox/core/constants/app_configs.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AuthRepository {
  SupabaseClient get _client => Supabase.instance.client;
  User? get currentUser => _client.auth.currentUser;

  Future<Either<String, bool>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return right(result.user != null);
    } on AuthException catch (e) {
      return left('Registration failed: ${e.message}');
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> register({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (result.user?.id == null || result.user?.email == null) {
        return left('Registration failed: User not verified or session error.');
      }
      return right(true);
    } on AuthException catch (e) {
      log(e.toString());
      return left('Registration failed: ${e.message}');
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        scopes: 'openid email profile',
        redirectTo: kDebugMode ? AppConfigs.debugRedirectUrl : AppConfigs.releaseRedirectUrl,
      );

      if (currentUser?.id != null && currentUser?.email != null) {
        return right(null);
      } else {
        return left('Authentication failed: User not verified or session error.');
      }
    } on AuthException catch (e) {
      return left('Registration failed: ${e.message}');
    } catch (e) {
      return left(e.toString());
    }
  }
}
