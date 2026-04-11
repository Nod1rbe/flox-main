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

  PageViewsFilterType _pageFilterFrom(AnalyticsPeriodType p) {
    switch (p) {
      case AnalyticsPeriodType.day:
        return PageViewsFilterType.day;
      case AnalyticsPeriodType.week:
        return PageViewsFilterType.week;
      case AnalyticsPeriodType.month:
        return PageViewsFilterType.month;
    }
  }

  AnalyticsPeriodType _analyticsPeriodFrom(PageViewsFilterType r) {
    switch (r) {
      case PageViewsFilterType.day:
        return AnalyticsPeriodType.day;
      case PageViewsFilterType.week:
        return AnalyticsPeriodType.week;
      case PageViewsFilterType.month:
        return AnalyticsPeriodType.month;
    }
  }

  void _onGlobalPeriodChanged(PageViewsFilterType range) {
    _analyticsCubit.updatePeriod(_analyticsPeriodFrom(range));
    _pageViewsCubit.updateBarFilterPeriod(range);
    _pageViewsCubit.updatePieFilterPeriod(range);
  }

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
            final r = _pageFilterFrom(_analyticsCubit.state.periodFilter);
            _pageViewsCubit.updateBarFilterPeriod(r);
            _pageViewsCubit.updatePieFilterPeriod(r);
            _analyticsCubit.getAnalytics(
              funnelId: funnel.id!,
              selectedPageIds: funnel.pageIds,
              pageViews: state.pageViews,
            );
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Analytics',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Funnel bo‘yicha tashriflar, sahifalar va leadlar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.subtitle,
                              ),
                            ),
                          ],
                        ),
                        FunnelSelectionDropDown().centerRight,
                      ],
                    ),
                    const SizedBox(height: 20),
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
                                    border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.45)),
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
                            const SizedBox(height: 20),
                            BlocBuilder<AnalyticsCubit, AnalyticsState>(
                              builder: (context, aState) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tashriflar va davr',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Grafiklar, sahifa statistikasi va jadval bir xil davr bo‘yicha',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.subtitle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FilterPeriodChips(
                                      selectedRange: _pageFilterFrom(aState.periodFilter),
                                      onSelected: _onGlobalPeriodChanged,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 14),
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
                                        showPeriodChips: false,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: TotalVisitsByPlatform(
                                        views: filteredPie,
                                        selectedRange: state.pieFilter,
                                        isLoading: state.getStatus.isLoading,
                                        showPeriodChips: false,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 28),
                            BlocBuilder<PageViewsCubit, PageViewsState>(
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Leadlar',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        Text(
                                          'Sessiya va forma maydonlari',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.subtitle,
                                          ),
                                        ),
                                      ],
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
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _analyticsCubit.exportLeadsToExcelCompatibleCsv,
                                icon: const Icon(Icons.download_rounded, size: 20),
                                label: const Text('Excel (.csv)'),
                              ),
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
