import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/feature/main_dashboard/analytics/cubit/page_views_cubit/page_views_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FunnelSelectionDropDown extends StatefulWidget {
  const FunnelSelectionDropDown({super.key});

  @override
  State<FunnelSelectionDropDown> createState() => _FunnelSelectionDropDownState();
}

class _FunnelSelectionDropDownState extends State<FunnelSelectionDropDown> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageViewsCubit, PageViewsState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.selectedFunnel?.name ?? 'No projects yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 12),
            PopupMenuButton<String>(
              icon: Assets.icons.selector.svg(),
              color: AppColors.fillColor,
              tooltip: 'Select funnel',
              onSelected: (funnelId) {
                if (state.funnels.isEmpty) return;
                final selected = state.funnels.firstWhere(
                  (funnel) => funnel.id == funnelId,
                  orElse: () => state.funnels.first,
                );
                context.read<PageViewsCubit>().updateSelectedFunnel(selected);
              },
              itemBuilder: (context) => state.funnels.map((funnel) {
                return PopupMenuItem<String>(
                  value: funnel.id,
                  child: Text(
                    funnel.name ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
