import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/main_dashboard/analytics/cubit/page_views_cubit/page_views_cubit.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flutter/material.dart';

class FilterPeriodChips extends StatelessWidget {
  final PageViewsFilterType selectedRange;
  final void Function(PageViewsFilterType) onSelected;

  const FilterPeriodChips({
    super.key,
    required this.selectedRange,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: PageViewsFilterType.values.map((range) {
        final label = range.name;
        final isSelected = range == selectedRange;
        return TappableComponent(
          onTap: () => onSelected(range),
          borderRadius: 10,
          child: Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.dividerColor.withValues(alpha: 0.65),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
