import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/submission_status.dart';
import 'package:flox/core/utils/file_download.dart';
import 'package:flox/feature/main_dashboard/analytics/data/models/analytics_model/analytics_model.dart';
import 'package:flox/feature/main_dashboard/analytics/data/models/page_views_model/page_views_model.dart';
import 'package:flox/feature/main_dashboard/analytics/data/repository/analytics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

part 'analytics_state.dart';

@injectable
class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _analyticsRepository;
  List<int> _selectedPageIds = const [];
  List<PageViewsModel> _currentPageViews = const [];

  AnalyticsCubit(this._analyticsRepository) : super(const AnalyticsState());

  getAnalytics({
    required String funnelId,
    required List<int> selectedPageIds,
    required List<PageViewsModel> pageViews,
  }) async {
    _selectedPageIds = _dedupeIdsInOrder(selectedPageIds);
    _currentPageViews = pageViews;
    emit(state.copyWith(getStatus: SubmissionStatus.loading));
    final result = await _analyticsRepository.getAnalytics(funnelId: funnelId);
    result.fold(
      (l) => emit(state.copyWith(getStatus: SubmissionStatus.failure, errorMessage: l)),
      (r) async {
        await Future.microtask(() => _recomputeDerived(r));
        emit(state.copyWith(getStatus: SubmissionStatus.success, analytics: r));
      },
    );
  }

  void updatePeriod(AnalyticsPeriodType period) {
    emit(state.copyWith(periodFilter: period));
    _recomputeDerived(state.analytics);
  }

  void _recomputeDerived(List<AnalyticsModel> analytics) {
    final filtered = _filterByPeriod(
      analytics,
      period: state.periodFilter,
      dateSelector: (e) => e.createdAt,
    );
    final filteredViews = _filterByPeriod(
      _currentPageViews,
      period: state.periodFilter,
      dateSelector: (e) => e.date,
    );
    final grouped = _groupAnalyticsByFieldName(filtered);
    final sourceByPage = _topSourceByPage(filteredViews);
    final leads = _buildLeadRows(filtered, sourceByPage);

    emit(
      state.copyWith(
        groupedAnalytics: grouped,
        leadRows: leads,
      ),
    );
  }

  List<T> _filterByPeriod<T>(
    List<T> data, {
    required AnalyticsPeriodType period,
    required DateTime Function(T item) dateSelector,
  }) {
    final now = DateTime.now();
    return data.where((item) {
      final date = dateSelector(item);
      switch (period) {
        case AnalyticsPeriodType.day:
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case AnalyticsPeriodType.week:
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              date.isBefore(endOfWeek.add(const Duration(days: 1)));
        case AnalyticsPeriodType.month:
          return date.year == now.year && date.month == now.month;
      }
    }).toList();
  }

  Map<int, String> _topSourceByPage(List<PageViewsModel> views) {
    final Map<int, Map<String, int>> aggregates = {};
    for (final view in views) {
      final stats = aggregates.putIfAbsent(view.pageId, () => {
            'Telegram': 0,
            'Instagram': 0,
            'X': 0,
            'Facebook': 0,
          });
      stats['Telegram'] = (stats['Telegram'] ?? 0) + view.telegram;
      stats['Instagram'] = (stats['Instagram'] ?? 0) + view.instagram;
      stats['X'] = (stats['X'] ?? 0) + view.x;
      stats['Facebook'] = (stats['Facebook'] ?? 0) + view.facebook;
    }

    final Map<int, String> result = {};
    aggregates.forEach((pageId, stats) {
      final top = stats.entries.reduce((a, b) => a.value >= b.value ? a : b);
      result[pageId] = top.value == 0 ? '-' : top.key;
    });
    return result;
  }

  /// Sessiya uchun saqlangan `traffic_source` (flox-app); yo‘q bo‘lsa — sahifa bo‘yicha fallback.
  String _leadTrafficSource(List<AnalyticsModel> sessionEvents, Map<int, String> sourceByPageFallback) {
    for (final e in sessionEvents) {
      final raw = e.trafficSource?.trim();
      if (raw != null && raw.isNotEmpty) {
        return _sourceLabel(raw);
      }
    }
    final reachedPage = sessionEvents.map((e) => e.pageId).fold<int>(0, (a, b) => a > b ? a : b);
    return sourceByPageFallback[reachedPage] ?? '-';
  }

  String _sourceLabel(String raw) {
    switch (raw.toLowerCase()) {
      case 'telegram':
        return 'Telegram';
      case 'instagram':
        return 'Instagram';
      case 'x':
        return 'X';
      case 'facebook':
        return 'Facebook';
      default:
        if (raw.isEmpty) return '-';
        return raw[0].toUpperCase() + raw.substring(1).toLowerCase();
    }
  }

  List<int> _dedupeIdsInOrder(List<int> ids) {
    final seen = <int>{};
    return [for (final id in ids) if (seen.add(id)) id];
  }

  List<AnalyticsLeadRow> _buildLeadRows(List<AnalyticsModel> analytics, Map<int, String> sourceByPage) {
    final Map<String, List<AnalyticsModel>> bySession = {};
    for (final item in analytics) {
      bySession.putIfAbsent(item.sessionId, () => []).add(item);
    }

    final List<AnalyticsLeadRow> rows = bySession.entries.map((entry) {
      final sessionEvents = entry.value;
      sessionEvents.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final reachedPage = sessionEvents.map((e) => e.pageId).fold<int>(0, (a, b) => a > b ? a : b);
      final createdAt = sessionEvents.first.createdAt;
      final Map<String, String> fields = {};
      for (final event in sessionEvents) {
        final key = (event.fieldName ?? '').trim();
        if (key.isEmpty) continue;
        fields[key] = event.value ?? '';
      }

      return AnalyticsLeadRow(
        sessionId: entry.key,
        createdAt: createdAt,
        reachedPageId: reachedPage,
        source: _leadTrafficSource(sessionEvents, sourceByPage),
        fields: fields,
      );
    }).toList();

    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }

  Map<String, List<String>> _groupAnalyticsByFieldName(List<AnalyticsModel> analyticsList) {
    final Map<String, List<String>> grouped = {};

    for (final analytic in analyticsList) {
      String fieldName = (analytic.fieldName ?? '').trim();
      if (fieldName.isEmpty) {
        fieldName = 'anonymous';
      }
      grouped.putIfAbsent(fieldName, () => []).add(analytic.value ?? '');
    }
    return grouped;
  }

  void exportLeadsToExcelCompatibleCsv() {
    final rows = state.leadRows;
    if (rows.isEmpty) return;

    final Set<String> dynamicKeys = {};
    for (final row in rows) {
      dynamicKeys.addAll(row.fields.keys);
    }
    final orderedKeys = dynamicKeys.toList()..sort();
    final prettyFieldHeaders = orderedKeys.map(_beautifyHeader).toList();

    final headers = ['Session ID', 'Reached Page', 'Source', 'Created At', ...prettyFieldHeaders];
    final buffer = StringBuffer();

    // Excel-friendly report meta section.
    buffer.writeln(_escapeCsv('Report period') + ',' + _escapeCsv(state.periodFilter.label));
    buffer.writeln(
      _escapeCsv('Generated at') + ',' + _escapeCsv(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())),
    );
    buffer.writeln(_escapeCsv('Collected fields') + ',' + _escapeCsv(prettyFieldHeaders.join(', ')));
    buffer.writeln(); // visual separator before tabular data
    buffer.writeln(headers.map(_escapeCsv).join(','));

    for (final row in rows) {
      final values = [
        row.sessionId,
        row.reachedPageId.toString(),
        row.source,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(row.createdAt),
        ...orderedKeys.map((k) => row.fields[k] ?? ''),
      ];
      buffer.writeln(values.map(_escapeCsv).join(','));
    }

    final fileName = 'leads_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv';
    downloadTextFile(fileName: fileName, content: buffer.toString());
  }

  String _escapeCsv(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  String _beautifyHeader(String raw) {
    final cleaned = raw.replaceAll('_', ' ').trim();
    if (cleaned.isEmpty) return raw;
    return cleaned
        .split(' ')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  void groupAnalyticsByFieldName(List<AnalyticsModel> analyticsList) {
    // Backward-compatible wrapper.
    emit(state.copyWith(groupedAnalytics: _groupAnalyticsByFieldName(analyticsList)));
  }
}
