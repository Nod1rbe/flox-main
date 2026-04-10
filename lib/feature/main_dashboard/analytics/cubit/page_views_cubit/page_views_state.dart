part of 'page_views_cubit.dart';

final class PageViewsState extends Equatable {
  final SubmissionStatus getStatus;
  final String errorMessage;
  final List<FunnelProjectsModel> funnels;
  final FunnelProjectsModel? selectedFunnel;
  final List<PageViewsModel> pageViews;
  final PageViewsFilterType barFilter;
  final PageViewsFilterType pieFilter;

  const PageViewsState({
    this.getStatus = SubmissionStatus.initial,
    this.errorMessage = '',
    this.funnels = const [],
    this.selectedFunnel,
    this.pageViews = const [],
    this.barFilter = PageViewsFilterType.week,
    this.pieFilter = PageViewsFilterType.week,
  });

  PageViewsState copyWith({
    SubmissionStatus? getStatus,
    String? errorMessage,
    List<FunnelProjectsModel>? funnels,
    FunnelProjectsModel? selectedFunnel,
    List<PageViewsModel>? pageViews,
    PageViewsFilterType? barFilter,
    PageViewsFilterType? pieFilter,
  }) {
    return PageViewsState(
      getStatus: getStatus ?? this.getStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      funnels: funnels ?? this.funnels,
      selectedFunnel: selectedFunnel ?? this.selectedFunnel,
      pageViews: pageViews ?? this.pageViews,
      barFilter: barFilter ?? this.barFilter,
      pieFilter: pieFilter ?? this.pieFilter,
    );
  }

  @override
  List<Object?> get props => [
        getStatus,
        errorMessage,
        funnels,
        selectedFunnel,
        pageViews,
        barFilter,
        pieFilter,
      ];
}

enum PageViewsFilterType {
  day(name: 'Day'),
  week(name: 'Week'),
  month(name: 'Month');

  final String name;
  const PageViewsFilterType({required this.name});
}
