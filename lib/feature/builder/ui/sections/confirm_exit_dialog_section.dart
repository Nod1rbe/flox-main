import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/blocs/builder_manager_bloc/builder_manager_cubit.dart';
import 'package:flox/feature/builder/ui/model/page_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmExitDialogSection extends StatelessWidget {
  final String funnelId;
  final List<PageData> pages;
  const ConfirmExitDialogSection({super.key, required this.funnelId, required this.pages});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.layoutBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Unsaved Changes', style: TextStyle(color: AppColors.white)),
      content: const Text(
        'Do you want to save your changes before exiting?',
        style: TextStyle(color: AppColors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => context.router.pop(),
          child: const Text('Discard', style: TextStyle(color: AppColors.primary)),
        ),
        BlocBuilder<BuilderManagerCubit, BuilderManagerState>(
          builder: (context, state) {
            return TextButton(
              onPressed: state.saveStatus.isLoading
                  ? null
                  : () async {
                      await context.read<BuilderManagerCubit>().publishFunnel(pages: pages, funnelId: funnelId);
                      context.router.pop(true);
                    },
              child: state.saveStatus.isLoading
                  ? CupertinoActivityIndicator(color: AppColors.white, radius: 10)
                  : const Text('Save', style: TextStyle(color: AppColors.primary)),
            );
          },
        ),
      ],
    );
  }
}
