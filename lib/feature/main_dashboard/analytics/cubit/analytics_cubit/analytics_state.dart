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

final class AnalyticsState extends Equatable {
  final SubmissionStatus getStatus;
  final String errorMessage;
  final List<AnalyticsModel> analytics;
  final List<AnalyticsLeadRow> leadRows;
  final AnalyticsPeriodType periodFilter;
  final Map<String, List<String>> groupedAnalytics;

  const AnalyticsState({
    this.getStatus = SubmissionStatus.initial,
    this.errorMessage = '',
    this.analytics = const [],
    this.leadRows = const [],
    this.periodFilter = AnalyticsPeriodType.week,
    this.groupedAnalytics = const {},
  });

  AnalyticsState copyWith({
    SubmissionStatus? getStatus,
    String? errorMessage,
    List<AnalyticsModel>? analytics,
    List<AnalyticsLeadRow>? leadRows,
    AnalyticsPeriodType? periodFilter,
    Map<String, List<String>>? groupedAnalytics,
  }) {
    return AnalyticsState(
      getStatus: getStatus ?? this.getStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      analytics: analytics ?? this.analytics,
      leadRows: leadRows ?? this.leadRows,
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
        periodFilter,
        groupedAnalytics,
      ];
}
