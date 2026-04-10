import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/blocs/builder_manager_bloc/builder_manager_cubit.dart';
import 'package:flox/ui_components/elements/page_layout/page_add_button.dart';
import 'package:flox/ui_components/elements/page_layout/page_button.dart';
import 'package:flox/ui_components/elements/shimmer_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PagesLayout extends StatelessWidget {
  final int selectedPage;
  final int pageCount;
  final VoidCallback onAddPage;
  final ValueChanged<int> onSelectPage;

  const PagesLayout({
    super.key,
    required this.selectedPage,
    required this.pageCount,
    required this.onAddPage,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.layoutBackground,
        border: Border(right: BorderSide(color: AppColors.white, width: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            'Pages',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<BuilderManagerCubit, BuilderManagerState>(
            builder: (context, state) {
              final bool loading = state.getProjectStatus.isLoading;
              return Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Column(
                        spacing: 16,
                        children: List.generate(loading ? 3 : pageCount, (index) {
                          final isSelected = index == selectedPage;
                          return ShimmerElement(
                            isLoading: loading,
                            baseColor: AppColors.cardColor,
                            height: 50,
                            width: 50,
                            radius: 8,
                            child: PageButton(
                              label: '${index + 1}',
                              isSelected: isSelected,
                              onTap: () => onSelectPage(index),
                              onRemove: () => context.read<BuilderCubit>().removePage(index),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      PageAddButton(
                        onTap: state.getProjectStatus.isLoading
                            ? () {}
                            : () {
                                onAddPage();
                                onSelectPage(pageCount);
                              },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
