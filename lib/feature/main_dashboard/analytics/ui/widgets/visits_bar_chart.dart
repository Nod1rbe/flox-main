import 'package:fl_chart/fl_chart.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/build_context_extensions.dart';
import 'package:flox/core/extensions/color_extension.dart';
import 'package:flox/feature/main_dashboard/analytics/cubit/page_views_cubit/page_views_cubit.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/filter_period_chips.dart';
import 'package:flox/ui_components/components/base_container_component.dart';
import 'package:flox/ui_components/elements/shimmer_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VisitsBarChart extends StatefulWidget {
  final bool isLoading;
  final List<Map<String, double>> barData;
  final double maxY;
  final PageViewsFilterType selectedRange;
  const VisitsBarChart({
    super.key,
    this.isLoading = false,
    required this.barData,
    required this.maxY,
    required this.selectedRange,
  });

  @override
  State<StatefulWidget> createState() => VisitsBarChartState();
}

class VisitsBarChartState extends State<VisitsBarChart> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ShimmerElement(
      isLoading: widget.isLoading,
      height: context.height * 0.4,
      width: double.infinity,
      radius: 16,
      child: BaseContainerComponent(
        height: context.height * 0.4,
        padding: const EdgeInsets.all(20),
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  FilterPeriodChips(
                    selectedRange: widget.selectedRange,
                    onSelected: context.read<PageViewsCubit>().updateBarFilterPeriod,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: widget.barData.isEmpty && !widget.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 44),
                          child: Text(
                            'No data available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : BarChart(
                        mainBarData(),
                        duration: animDuration,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 20,
    List<int> showTooltips = const [],
  }) {
    barColor ??= AppColors.white;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? AppColors.primary : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: AppColors.primary.darken(80))
              : const BorderSide(color: AppColors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: widget.maxY,
            color: AppColors.pageBackground,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  BarChartData mainBarData() {
    final interval = widget.maxY > 0 ? (widget.maxY / 5).ceilToDouble() : 1.0;
    return BarChartData(
      maxY: widget.maxY + 0.1,
      minY: -0.1,
      barGroups: List.generate(widget.barData.length, (i) {
        final value = widget.barData[i].values.first;
        return makeGroupData(i, value, isTouched: i == touchedIndex);
      }),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => AppColors.cardColor,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: barToolTipData,
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            reservedSize: 40,
            maxIncluded: true,
            minIncluded: true,
            getTitlesWidget: getLeftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        horizontalInterval: interval,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppColors.white.withValues(alpha: 0.1),
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final index = value.toInt();
    if (index < 0 || index >= widget.barData.length) {
      return const SizedBox.shrink();
    }
    final label = widget.barData[index].keys.first;
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(label, style: style),
    );
  }

  BarTooltipItem? barToolTipData(
    BarChartGroupData group,
    int groupIndex,
    BarChartRodData rod,
    int rodIndex,
  ) {
    if (groupIndex < 0 || groupIndex >= widget.barData.length) return null;

    final label = widget.barData[groupIndex].keys.first;

    return BarTooltipItem(
      '$label\n',
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      children: <TextSpan>[
        TextSpan(
          text: rod.toY.toStringAsFixed(0),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    String label;
    if (value >= 1000000) {
      label = '${(value / 1000000).toStringAsFixed(0)}M';
    } else if (value >= 1000) {
      label = '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      label = value.toStringAsFixed(0);
    }
    if (label.startsWith('-')) {
      label = label.substring(1);
    }

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
