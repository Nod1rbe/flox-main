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

@injectable
class PageViewsCubit extends Cubit<PageViewsState> {
  final FunnelsProjectsRepository _projectsRepository;
  final AnalyticsRepository _analyticsRepository;
  PageViewsCubit(this._projectsRepository, this._analyticsRepository) : super(PageViewsState());

  Future<void> getFunnels() async {
    emit(state.copyWith(getStatus: SubmissionStatus.loading));
    final result = await _projectsRepository.getFunnels();
    result.fold(
      (l) => emit(state.copyWith(getStatus: SubmissionStatus.failure, errorMessage: l)),
      (r) async {
        FunnelProjectsModel? selectedFunnel;
        List<PageViewsModel> pageViews = [];

        if (r.isNotEmpty) {
          selectedFunnel = r.first;
          emit(state.copyWith(selectedFunnel: selectedFunnel));
          final pageViewResult = await _analyticsRepository.getPageViews(pageIds: selectedFunnel.pageIds);
          pageViewResult.fold(
            (err) {
              emit(state.copyWith(getStatus: SubmissionStatus.failure, errorMessage: err));
              return;
            },
            (views) => pageViews = views,
          );
        }
        emit(state.copyWith(
          getStatus: SubmissionStatus.success,
          funnels: r,
          pageViews: pageViews,
        ));
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

  updateSelectedFunnel(FunnelProjectsModel funnel) => emit(state.copyWith(selectedFunnel: funnel));

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
    if (data.isEmpty) return 0;
    final allValues = data.expand((map) => map.values);
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    return maxValue;
  }

  List<Map<String, double>> barData() {
    final filteredViews = _filterByDate([...state.pageViews], state.barFilter);
    if (filteredViews.isEmpty) return [];

    final Map<int, double> grouped = {};
    for (int i = 0; i < filteredViews.length; i++) {
      final view = filteredViews[i];
      final totalViews = (view.telegram + view.instagram + view.x + view.facebook).toDouble();
      grouped[i] = totalViews;
    }

    return grouped.entries.map((entry) {
      return {'${entry.key + 1}-Page': entry.value};
    }).toList();
  }

  updateBarFilterPeriod(PageViewsFilterType period) => emit(state.copyWith(barFilter: period));
  updatePieFilterPeriod(PageViewsFilterType period) => emit(state.copyWith(pieFilter: period));
}
