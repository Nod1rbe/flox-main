import 'package:auto_route/annotations.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/di/injection.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
import 'package:flox/core/extensions/build_context_extensions.dart';
import 'package:flox/core/extensions/date_extensions.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/feature/main_dashboard/analytics/cubit/analytics_cubit/analytics_cubit.dart';
import 'package:flox/feature/main_dashboard/analytics/cubit/page_views_cubit/page_views_cubit.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/analytics_data_table.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/analytics_overview_item.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/filter_period_chips.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/funnel_selection_drop_down.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/total_visits_by_platform.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/visits_bar_chart.dart';
import 'package:flox/ui_components/components/base_container_component.dart';
import 'package:flox/ui_components/components/horizontal_divider_component.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flox/ui_components/elements/shimmer_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final PageViewsCubit _pageViewsCubit;
  late final AnalyticsCubit _analyticsCubit;

  @override
  void initState() {
    super.initState();
    _pageViewsCubit = getIt<PageViewsCubit>();
    _analyticsCubit = getIt<AnalyticsCubit>();
    _pageViewsCubit.getFunnels();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _pageViewsCubit), BlocProvider.value(value: _analyticsCubit)],
      child: BlocListener<PageViewsCubit, PageViewsState>(
        listenWhen: (prev, cur) => prev.selectedFunnel != cur.selectedFunnel,
        listener: (context, state) {
          final funnel = state.selectedFunnel;
          if (funnel != null && funnel.id != null) {
            _pageViewsCubit.getViews(funnel.pageIds).then((_) {
              _analyticsCubit.getAnalytics(
                funnelId: funnel.id ?? '',
                selectedPageIds: funnel.pageIds,
                pageViews: _pageViewsCubit.state.pageViews,
              );
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.only(left: 24, top: 20, right: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Analytics',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        FunnelSelectionDropDown().centerRight,
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            BlocConsumer<PageViewsCubit, PageViewsState>(
                              listenWhen: (prev, cur) => prev.getStatus != cur.getStatus,
                              listener: (context, state) {
                                if (state.getStatus.isFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.errorMessage)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return ShimmerElement(
                                  isLoading: state.getStatus.isLoading,
                                  width: double.infinity,
                                  height: 100,
                                  radius: 16,
                                  child: BaseContainerComponent(
                                    height: 100,
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AnalyticsOverviewItem(
                                          iconColor: AppColors.primary,
                                          icon: Assets.icons.calendar,
                                          title: 'Created on',
                                          data: state.selectedFunnel?.createdAt?.formattedDate ?? '—',
                                        ),
                                        HorizontalDividerComponent(),
                                        AnalyticsOverviewItem(
                                          iconColor: Colors.greenAccent,
                                          icon: Assets.icons.eye,
                                          title: 'Total visits',
                                          data: _pageViewsCubit.formattedTotalVisits(),
                                        ),
                                        HorizontalDividerComponent(),
                                        AnalyticsOverviewItem(
                                          iconColor: Colors.pinkAccent,
                                          icon: Assets.icons.link,
                                          title: 'Top source',
                                          data: _pageViewsCubit.topSource(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<PageViewsCubit, PageViewsState>(
                              builder: (context, state) {
                                final filteredPie = _pageViewsCubit.getFilteredViewsForPie();
                                final maxY = _pageViewsCubit.barMaxY();
                                final barData = _pageViewsCubit.barData();
                                return Row(
                                  spacing: 16,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: VisitsBarChart(
                                        maxY: maxY,
                                        barData: barData,
                                        selectedRange: state.barFilter,
                                        isLoading: state.getStatus.isLoading,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: TotalVisitsByPlatform(
                                        views: filteredPie,
                                        selectedRange: state.pieFilter,
                                        isLoading: state.getStatus.isLoading,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<PageViewsCubit, PageViewsState>(
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Leads data',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    TappableComponent(
                                      onTap: () => _analyticsCubit.getAnalytics(
                                        funnelId: state.selectedFunnel?.id ?? '',
                                        selectedPageIds: state.selectedFunnel?.pageIds ?? const [],
                                        pageViews: _pageViewsCubit.state.pageViews,
                                      ),
                                      borderRadius: 6,
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Assets.icons.refresh.svg(
                                            colorFilter: ColorFilter.mode(
                                              AppColors.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<AnalyticsCubit, AnalyticsState>(
                              builder: (context, analyticsState) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FilterPeriodChips(
                                      selectedRange: switch (analyticsState.periodFilter) {
                                        AnalyticsPeriodType.day => PageViewsFilterType.day,
                                        AnalyticsPeriodType.week => PageViewsFilterType.week,
                                        AnalyticsPeriodType.month => PageViewsFilterType.month,
                                      },
                                      onSelected: (range) {
                                        final period = switch (range) {
                                          PageViewsFilterType.day => AnalyticsPeriodType.day,
                                          PageViewsFilterType.week => AnalyticsPeriodType.week,
                                          PageViewsFilterType.month => AnalyticsPeriodType.month,
                                        };
                                        _analyticsCubit.updatePeriod(period);
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: _analyticsCubit.exportLeadsToExcelCompatibleCsv,
                                      child: const Text('Export Excel (.csv)'),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<AnalyticsCubit, AnalyticsState>(
                              builder: (context, state) {
                                return BaseContainerComponent(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Page performance (selected funnel)',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      if (state.pagePerformanceRows.isEmpty)
                                        const Text(
                                          'No performance data for selected period',
                                          style: TextStyle(color: AppColors.white),
                                        )
                                      else
                                        ...state.pagePerformanceRows.map((row) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Page ${row.pageId}',
                                                    style: const TextStyle(color: AppColors.white),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Users: ${row.usersReached}',
                                                    style: const TextStyle(color: AppColors.white),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Events: ${row.events}',
                                                    style: const TextStyle(color: AppColors.white),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Source: ${row.topSource}',
                                                    style: const TextStyle(color: AppColors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<AnalyticsCubit, AnalyticsState>(
                              buildWhen: (prev, cur) =>
                                  prev.leadRows != cur.leadRows ||
                                  prev.getStatus != cur.getStatus ||
                                  prev.periodFilter != cur.periodFilter,
                              builder: (context, state) {
                                if (state.getStatus.isLoading) {
                                  return Column(
                                    children: List.generate(3, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: ShimmerElement(
                                          isLoading: state.getStatus.isLoading,
                                          height: 30,
                                          width: (context.width - 300) / index,
                                          child: SizedBox(),
                                        ).centerLeft,
                                      );
                                    }),
                                  );
                                }
                                if (state.leadRows.isEmpty) {
                                  return const Text("No analytics data available");
                                }
                                return AnalyticsDataTable(rows: state.leadRows);
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
