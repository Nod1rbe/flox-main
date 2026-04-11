import 'package:dartz/dartz.dart';
import 'package:flox/feature/main_dashboard/analytics/data/models/analytics_model/analytics_model.dart';
import 'package:flox/feature/main_dashboard/analytics/data/models/page_views_model/page_views_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AnalyticsRepository {
  SupabaseClient get _client => Supabase.instance.client;
  PostgrestQueryBuilder get _analyticsTable => _client.from('analytics');
  PostgrestQueryBuilder get _pageViewsTable => _client.from('page_views');

  Future<Either<String, List<AnalyticsModel>>> getAnalytics({required String funnelId}) async {
    try {
      final response = await _analyticsTable.select().eq('funnel_id', funnelId);
      final analytics = <AnalyticsModel>[];
      for (final raw in response) {
        analytics.add(AnalyticsModel.fromJson(Map<String, dynamic>.from(raw as Map)));
      }
      return right(analytics);
    } catch (e) {
      debugPrint(e.toString());
      return left(e.toString());
    }
  }

  Future<Either<String, List<PageViewsModel>>> getPageViews({required List<int> pageIds}) async {
    try {
      if (pageIds.isEmpty) return right(const []);
      final seenIds = <int>{};
      final uniquePageIds = <int>[];
      for (final id in pageIds) {
        if (seenIds.add(id)) uniquePageIds.add(id);
      }
      final pageViews = <PageViewsModel>[];
      for (final pageId in uniquePageIds) {
        final response = await _pageViewsTable.select().eq('page_id', pageId);
        for (final raw in response) {
          pageViews.add(PageViewsModel.fromJson(Map<String, dynamic>.from(raw as Map)));
        }
      }
      return right(pageViews);
    } catch (e) {
      debugPrint(e.toString());
      return left('Failed to load page views: $e');
    }
  }
}
