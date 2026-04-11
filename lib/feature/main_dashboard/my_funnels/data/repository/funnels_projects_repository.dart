import 'package:dartz/dartz.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/models/funnel_projects_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class FunnelsProjectsRepository {
  SupabaseClient get _supabase => Supabase.instance.client;
  String? get _userId => _supabase.auth.currentUser?.id;

  PostgrestQueryBuilder get _funnels => _supabase.from('funnels');
  PostgrestQueryBuilder get _pages => _supabase.from('pages');
  PostgrestQueryBuilder get _analytics => _supabase.from('analytics');
  PostgrestQueryBuilder get _pageViews => _supabase.from('page_views');

  static List<int> _parseIdColumnRows(dynamic response) {
    final ids = <int>[];
    final list = response is List ? response : const [];
    for (final raw in list) {
      if (raw is! Map) continue;
      final m = Map<String, dynamic>.from(raw);
      final id = m['id'];
      if (id is int) {
        ids.add(id);
      } else if (id is num) {
        ids.add(id.toInt());
      }
    }
    return ids;
  }

  Future<Either<String, List<FunnelProjectsModel>>> getFunnels() async {
    try {
      if (_userId == null) return left('User is not found');

      final response = await _funnels.select().eq('user_id', _userId!).order(
            'created_at',
            ascending: true,
          );

      final List<FunnelProjectsModel> funnels =
          response.map((funnel) => FunnelProjectsModel.fromJson(funnel)).toList();

      return right(funnels);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, FunnelProjectsModel>> createFunnel({
    required String name,
    String? description,
  }) async {
    try {
      if (_userId == null) return left('User is not found');

      final response = await _funnels
          .insert({
            'user_id': _userId,
            'name': name,
            'description': description,
          })
          .select()
          .single();

      if (response.isEmpty) return left('Insertion failed');
      final funnel = FunnelProjectsModel.fromJson(response);
      return right(funnel);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> updateFunnel({
    required String id,
    String? name,
    String? description,
    int? pageCount,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (pageCount != null) updates['page_count'] = pageCount;

      final response = await _funnels.update(updates).eq('id', id).select().single();
      if (response.isEmpty) return left('Update failed');
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  /// `funnels.page_ids` bo‘sh yoki eskirgan bo‘lsa ham — `pages` jadvalidan haqiqiy id lar.
  Future<Either<String, List<int>>> getPageIdsForFunnel(String funnelId) async {
    try {
      if (_userId == null) return left('User is not found');
      final response = await _pages.select('id').eq('funnel_id', funnelId).order('page_order', ascending: true);
      return right(_parseIdColumnRows(response));
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> deleteFunnel({required String id}) async {
    try {
      if (_userId == null) return left('User is not found');

      await _analytics.delete().eq('funnel_id', id);

      final pagesSnapshot = await _pages.select('id').eq('funnel_id', id);
      for (final pid in _parseIdColumnRows(pagesSnapshot)) {
        await _pageViews.delete().eq('page_id', pid);
      }

      await _pages.delete().eq('funnel_id', id);
      await _funnels.delete().eq('id', id).eq('user_id', _userId!);
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }
}
