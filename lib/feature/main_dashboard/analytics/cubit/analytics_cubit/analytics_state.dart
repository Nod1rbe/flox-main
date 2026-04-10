part of 'analytics_cubit.dart';

enum AnalyticsPeriodType {
  day(label: 'Day'),
  week(label: 'Week'),
  month(label: 'Month');

  final String label;
  const AnalyticsPeriodType({required this.label});
}

class AnalyticsLeadRow extends Equatable {
  final String sessionId;
  final DateTime createdAt;
  final int reachedPageId;
  final String source;
  final Map<String, String> fields;

  const AnalyticsLeadRow({
    required this.sessionId,
    required this.createdAt,
    required this.reachedPageId,
    required this.source,
    required this.fields,
  });

  @override
  List<Object?> get props => [sessionId, createdAt, reachedPageId, source, fields];
}

class PagePerformanceRow extends Equatable {
  final int pageId;
  final int usersReached;
  final int events;
  final String topSource;

  const PagePerformanceRow({
    required this.pageId,
    required this.usersReached,
    required this.events,
    required this.topSource,
  });

  @override
  List<Object?> get props => [pageId, usersReached, events, topSource];
}

final class AnalyticsState extends Equatable {
  final SubmissionStatus getStatus;
  final String errorMessage;
  final List<AnalyticsModel> analytics;
  final List<AnalyticsLeadRow> leadRows;
  final List<PagePerformanceRow> pagePerformanceRows;
  final AnalyticsPeriodType periodFilter;
  final Map<String, List<String>> groupedAnalytics;

  const AnalyticsState({
    this.getStatus = SubmissionStatus.initial,
    this.errorMessage = '',
    this.analytics = const [],
    this.leadRows = const [],
    this.pagePerformanceRows = const [],
    this.periodFilter = AnalyticsPeriodType.week,
    this.groupedAnalytics = const {},
  });

  AnalyticsState copyWith({
    SubmissionStatus? getStatus,
    String? errorMessage,
    List<AnalyticsModel>? analytics,
    List<AnalyticsLeadRow>? leadRows,
    List<PagePerformanceRow>? pagePerformanceRows,
    AnalyticsPeriodType? periodFilter,
    Map<String, List<String>>? groupedAnalytics,
  }) {
    return AnalyticsState(
      getStatus: getStatus ?? this.getStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      analytics: analytics ?? this.analytics,
      leadRows: leadRows ?? this.leadRows,
      pagePerformanceRows: pagePerformanceRows ?? this.pagePerformanceRows,
      periodFilter: periodFilter ?? this.periodFilter,
      groupedAnalytics: groupedAnalytics ?? this.groupedAnalytics,
    );
  }

  @override
  List<Object?> get props => [
        getStatus,
        errorMessage,
        analytics,
        leadRows,
        pagePerformanceRows,
        periodFilter,
        groupedAnalytics,
      ];
}
