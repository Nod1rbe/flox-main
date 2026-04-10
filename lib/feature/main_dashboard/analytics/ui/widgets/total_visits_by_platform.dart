import 'package:fl_chart/fl_chart.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/build_context_extensions.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/feature/main_dashboard/analytics/cubit/page_views_cubit/page_views_cubit.dart';
import 'package:flox/feature/main_dashboard/analytics/data/models/page_views_model/page_views_model.dart';
import 'package:flox/feature/main_dashboard/analytics/ui/widgets/filter_period_chips.dart';
import 'package:flox/ui_components/components/base_container_component.dart';
import 'package:flox/ui_components/elements/shimmer_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalVisitsByPlatform extends StatefulWidget {
  final List<PageViewsModel> views;
  final bool isLoading;
  final PageViewsFilterType selectedRange;

  const TotalVisitsByPlatform({super.key, required this.views, this.isLoading = false, required this.selectedRange});

  @override
  State<TotalVisitsByPlatform> createState() => _TotalVisitsByPlatformState();
}

class _TotalVisitsByPlatformState extends State<TotalVisitsByPlatform> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final sections = showingSections();

    return ShimmerElement(
      isLoading: widget.isLoading,
      height: context.height * 0.4,
      width: double.infinity,
      radius: 16,
      child: BaseContainerComponent(
        height: context.height * 0.4,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Social Media',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                FilterPeriodChips(
                  selectedRange: widget.selectedRange,
                  onSelected: context.read<PageViewsCubit>().updatePieFilterPeriod,
                ),
              ],
            ),
            Expanded(
              child: sections.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 34),
                        child: Text('No data available', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) return;
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      response == null ||
                                      response.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = response.touchedSection!.touchedSectionIndex;
                                });
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: sections,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final telegram = widget.views.fold<int>(0, (sum, v) => sum + v.telegram);
    final instagram = widget.views.fold<int>(0, (sum, v) => sum + v.instagram);
    final x = widget.views.fold<int>(0, (sum, v) => sum + v.x);
    final facebook = widget.views.fold<int>(0, (sum, v) => sum + v.facebook);

    final total = telegram + instagram + x + facebook;
    if (total == 0) return [];

    final data = [
      {
        'value': instagram.toDouble(),
        'title': 'Instagram',
        'color': const Color(0xFFE1306C),
        'icon': Assets.icons.instagramLogo,
      },
      {
        'value': facebook.toDouble(),
        'title': 'Facebook',
        'color': const Color(0xFF1877F2),
        'icon': Assets.icons.facebookLogo,
      },
      {
        'value': telegram.toDouble(),
        'title': 'Telegram',
        'color': const Color(0xFF0088CC),
        'icon': Assets.icons.telegramLogo,
      },
      {
        'value': x.toDouble(),
        'title': 'X',
        'color': const Color(0xFF000000),
        'icon': Assets.icons.xLogo,
      },
    ];

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      final value = data[i]['value'] as double;
      final percent = '${(value / total * 100).toStringAsFixed(0)}%';

      return PieChartSectionData(
        color: data[i]['color'] as Color,
        value: value,
        title: percent,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 20.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        badgeWidget: _Badge(
          data[i]['icon'] as SvgGenImage,
          size: widgetSize,
          borderColor: Colors.white,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });

  final SvgGenImage svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(child: svgAsset.svg()),
    );
  }
}
