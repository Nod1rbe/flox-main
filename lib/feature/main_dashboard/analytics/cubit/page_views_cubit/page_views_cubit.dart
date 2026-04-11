import 'package:dartz/dartz.dart' show Either;
import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/submission_status.dart';
import 'package:flox/feature/main_dashboard/analytics/data/models/page_views_model/page_views_model.dart';
import 'package:flox/feature/main_dashboard/analytics/data/repository/analytics_repository.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/models/funnel_projects_model.dart';
import 'package:flox/feature/main_dashboard/my_funnels/data/repository/funnels_projects_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

part 'page_views_state.dart';

/// `funnels.page_ids` da bir xil id takrorlansa, `page_views` qatorlari ikki marta yig‘ilmasin.
List<int> _dedupePageIdsInOrder(List<int> pageIds) {
  final seen = <int>{};
  return [for (final id in pageIds) if (seen.add(id)) id];
}

@injectable
class PageViewsCubit extends Cubit<PageViewsState> {
  PageViewsCubit(this._projectsRepository, this._analyticsRepository) : super(PageViewsState());

  final FunnelsProjectsRepository _projectsRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<List<int>> _resolvedPageIds(FunnelProjectsModel funnel) async {
    final fid = funnel.id;
    if (fid == null || fid.isEmpty) return funnel.pageIds;
    final Either<String, List<int>> idsResult = await _projectsRepository.getPageIdsForFunnel(fid);
    return idsResult.fold((_) => funnel.pageIds, (ids) => ids.isNotEmpty ? ids : funnel.pageIds);
  }

  Future<void> getFunnels() async {
    emit(state.copyWith(getStatus: SubmissionStatus.loading));
    final result = await _projectsRepository.getFunnels();
    await result.fold<Future<void>>(
      (l) async {
        emit(state.copyWith(getStatus: SubmissionStatus.failure, errorMessage: l));
      },
      (r) async {
        if (r.isEmpty) {
          emit(state.copyWith(
            getStatus: SubmissionStatus.success,
            funnels: r,
            selectedFunnel: null,
            pageViews: const [],
          ));
          return;
        }
        var selected = r.first;
        final ids = await _resolvedPageIds(selected);
        if (ids.isNotEmpty) {
          selected = selected.copyWith(pageIds: ids);
        }
        final pageViewResult = await _analyticsRepository.getPageViews(pageIds: selected.pageIds);
        await pageViewResult.fold(
          (err) async {
            emit(state.copyWith(getStatus: SubmissionStatus.failure, errorMessage: err));
          },
          (views) async {
            emit(state.copyWith(
              getStatus: SubmissionStatus.success,
              funnels: r,
              selectedFunnel: selected,
              pageViews: views,
            ));
          },
        );
      },
    );
  }

  Future<void> getViews(List<int> pageIds) async {
    emit(state.copyWith(getStatus: SubmissionStatus.loading));
    final result = await _analyticsRepository.getPageViews(pageIds: pageIds);
    result.fold(
      (l) => emit(state.copyWith(getStatus: SubmissionStatus.failure, errorMessage: l)),
      (r) => emit(state.copyWith(getStatus: SubmissionStatus.success, pageViews: r)),
    );
  }

  /// Funnel tanlanganda: `pages` jadvalidan id lar, keyin page_views.
  Future<void> selectFunnel(FunnelProjectsModel funnel) async {
    emit(state.copyWith(getStatus: SubmissionStatus.loading));
    final ids = await _resolvedPageIds(funnel);
    final enriched = ids.isNotEmpty ? funnel.copyWith(pageIds: ids) : funnel;
    final pageViewResult = await _analyticsRepository.getPageViews(pageIds: enriched.pageIds);
    pageViewResult.fold(
      (l) => emit(state.copyWith(getStatus: SubmissionStatus.failure, errorMessage: l)),
      (views) => emit(state.copyWith(
        getStatus: SubmissionStatus.success,
        selectedFunnel: enriched,
        pageViews: views,
      )),
    );
  }

  String formattedTotalVisits() {
    final total = state.pageViews.fold(0, (sum, view) => sum + view.telegram + view.instagram + view.x + view.facebook);
    return NumberFormat.decimalPattern().format(total);
  }

  String topSource() {
    final views = state.pageViews;
    if (views.isEmpty) return '-';
    int telegram = 0, instagram = 0, x = 0, facebook = 0;
    for (final view in views) {
      telegram += view.telegram;
      instagram += view.instagram;
      x += view.x;
      facebook += view.facebook;
    }
    final sourceMap = {'Telegram': telegram, 'Instagram': instagram, 'X': x, 'Facebook': facebook};
    return sourceMap.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  List<PageViewsModel> getFilteredViewsForPie() => _filterByDate(state.pageViews, state.pieFilter);

  List<PageViewsModel> _filterByDate(List<PageViewsModel> data, PageViewsFilterType filter) {
    final now = DateTime.now();
    if (filter == PageViewsFilterType.day) {
      return data
          .where((item) => item.date.year == now.year && item.date.month == now.month && item.date.day == now.day)
          .toList();
    } else if (filter == PageViewsFilterType.week) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return data
          .where((item) =>
              item.date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              item.date.isBefore(endOfWeek.add(const Duration(days: 1))))
          .toList();
    } else if (filter == PageViewsFilterType.month) {
      return data.where((item) => item.date.year == now.year && item.date.month == now.month).toList();
    }
    return data;
  }

  double barMaxY() {
    final data = barData();
    if (data.isEmpty) return 1;
    final allValues = data.expand((map) => map.values);
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue : 1;
  }

  /// Har bir `page_id` bo‘yicha jami tashriflar; ustunlar funnel `pageIds` tartibida.
  List<Map<String, double>> barData() {
    final filteredViews = _filterByDate([...state.pageViews], state.barFilter);
    if (filteredViews.isEmpty) return [];

    final byPageId = <int, double>{};
    for (final view in filteredViews) {
      final total = (view.telegram + view.instagram + view.x + view.facebook).toDouble();
      byPageId[view.pageId] = (byPageId[view.pageId] ?? 0) + total;
    }

    final orderedIds = _dedupePageIdsInOrder(state.selectedFunnel?.pageIds ?? const <int>[]);
    if (orderedIds.isEmpty) {
      final keys = byPageId.keys.toList()..sort();
      return keys.map((id) => <String, double>{'#$id': byPageId[id]!}).toList();
    }

    return orderedIds.asMap().entries.map((e) {
      final order = e.key + 1;
      final id = e.value;
      return <String, double>{'Sahifa $order': byPageId[id] ?? 0};
    }).toList();
  }

  void updateBarFilterPeriod(PageViewsFilterType period) => emit(state.copyWith(barFilter: period));
  void updatePieFilterPeriod(PageViewsFilterType period) => emit(state.copyWith(pieFilter: period));
}
