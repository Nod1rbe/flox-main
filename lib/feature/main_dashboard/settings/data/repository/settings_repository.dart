import 'package:dartz/dartz.dart';
import 'package:flox/feature/main_dashboard/settings/data/models/user_data_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class SettingsRepository {
  SupabaseClient get _client => Supabase.instance.client;
  PostgrestQueryBuilder get _userTable => _client.from('users');
  String? get _userId => _client.auth.currentUser?.id;
  String? get _email => _client.auth.currentUser?.email;

  Future<Either<String, UserDataModel>> getUserData() async {
    try {
      if (_userId == null) return left('User not found');
      final response = await _userTable.select().eq('id', _userId!).maybeSingle();
      if (response == null || response.isEmpty) return left('User not found');
      final UserDataModel userData = UserDataModel.fromJson(response).copyWith(email: _email);
      return right(userData);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> logout() async {
    try {
      await _client.auth.signOut();
      return right(null);
    } on AuthException catch (e) {
      return left('Logout failed: ${e.message}');
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> resetPassword({
    required String email,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return right(null);
    } on AuthException catch (e) {
      return left('Registration failed: ${e.message}');
    } catch (e) {
      return left(e.toString());
    }
  }
}
