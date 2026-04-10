import 'package:dartz/dartz.dart';
import 'package:flox/core/extensions/logger.dart';
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
      final List<AnalyticsModel> analytics = response.map((e) => AnalyticsModel.fromJson(e)).toList();
      return right(analytics);
    } catch (e) {
      debugPrint(e.toString());
      return left(e.toString());
    }
  }

  Future<Either<String, List<PageViewsModel>>> getPageViews({required List<int> pageIds}) async {
    try {
      final List<PageViewsModel> pageViews = [];
      for (int pageId in pageIds) {
        final response = await _pageViewsTable.select().eq('page_id', pageId);
        for (final item in response as List) {
          pageViews.add(PageViewsModel.fromJson(item));
        }
      }
      appLog(pageViews.length);
      appLog(pageViews);
      return right(pageViews);
    } catch (e) {
      debugPrint(e.toString());
      return left('Failed to load page views: $e');
    }
  }
}
