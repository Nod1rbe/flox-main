import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/feature/main_dashboard/my_funnels/bloc/funnel_projects_bloc.dart';
import 'package:flox/ui_components/components/atoms/button_atom.dart';
import 'package:flox/ui_components/components/base_container_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String funnelId;

  const DeleteConfirmationDialog({super.key, required this.funnelId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
          maxHeight: 400,
        ),
        child: BaseContainerComponent(
          padding: EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            children: [
              const Spacer(),
              Assets.icons.infoRedRounded.svg(),
              const SizedBox(height: 10),
              const Text(
                'Delete Funnel',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ).topCenter,
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to delete this funnel?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ).topCenter,
              const Spacer(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonAtom(
                    height: 32,
                    width: 80,
                    text: 'Cancel',
                    hoverColor: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: 8,
                    color: AppColors.transparent,
                    onTap: () => context.router.maybePop(),
                  ),
                  const SizedBox(width: 16),
                  BlocConsumer<FunnelProjectsBloc, FunnelProjectsState>(
                    listenWhen: (previous, current) => previous.deleteStatus != current.deleteStatus,
                    listener: (context, state) {
                      if (state.deleteStatus.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funnel deleted successfully'),
                          ),
                        );
                        context.router.maybePop(true);
                      }
                      if (state.deleteStatus.isFailure) {
                        final msg = state.deleteErrorMessage.trim().isEmpty
                            ? 'Failed to delete funnel'
                            : state.deleteErrorMessage;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ButtonAtom(
                        height: 32,
                        width: 100,
                        borderRadius: 8,
                        text: 'Delete',
                        loading: state.deleteStatus.isLoading,
                        onTap: () {
                          context.read<FunnelProjectsBloc>().add(
                                DeleteFunnelEvent(id: funnelId),
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
