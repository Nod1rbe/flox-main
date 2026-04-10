import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/core/routes/app_router.gr.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/blocs/builder_manager_bloc/builder_manager_cubit.dart';
import 'package:flox/feature/builder/ui/sections/confirm_exit_dialog_section.dart';
import 'package:flox/feature/main_dashboard/my_funnels/ui/widgets/links_view_dialog.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flox/ui_components/elements/builder_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderLayout extends StatelessWidget {
  final String funnelId;
  final String funnelName;
  const HeaderLayout({super.key, required this.funnelId, required this.funnelName});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BuilderManagerCubit, BuilderManagerState>(
      listenWhen: (previous, current) {
        return (previous.showLinksStatus != current.showLinksStatus && current.showLinksStatus.isSuccess) ||
            (previous.saveStatus != current.saveStatus &&
                (current.saveStatus.isSuccess || current.saveStatus.isFailure));
      },
      listener: (context, state) {
        if (state.showLinksStatus.isSuccess) {
          showDialog(
            context: context,
            builder: (context) {
              return LinksViewDialog(links: state.launcherLinks);
            },
          );
          context.read<BuilderCubit>().updateDidPagesChange(false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Funnel published successfully')));
        } else if (state.saveStatus.isSuccess) {
          context.read<BuilderCubit>().updateDidPagesChange(false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Funnel saved successfully')));
        } else if (state.saveStatus.isFailure || state.showLinksStatus.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final builderCubit = context.read<BuilderCubit>();
        return Container(
          padding: const EdgeInsets.only(left: 16, right: 24, top: 16, bottom: 16),
          decoration: BoxDecoration(color: AppColors.layoutBackground.withValues(alpha: 0.75)),
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: TappableComponent(
                  onTap: () {
                    if (builderCubit.state.didPagesChange) {
                      showDialog(
                        context: context,
                        useRootNavigator: true,
                        builder: (_) {
                          return BlocProvider.value(
                            value: context.read<BuilderManagerCubit>(),
                            child: ConfirmExitDialogSection(funnelId: funnelId, pages: builderCubit.state.pages),
                          );
                        },
                      ).then((value) {
                        if (value is bool && value) popFunction(context);
                      });
                    } else {
                      popFunction(context);
                    }
                  },
                  borderRadius: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Assets.icons.backIcon.svg(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                funnelName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              BuilderActionButton(
                icon: Assets.icons.link.svg(
                  height: 14,
                  colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                ),
                label: 'Links',
                loading: state.showLinksStatus.isLoading,
                onTap: () {
                  if (builderCubit.state.invalidAnalyticsFieldPositions.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please add analytics field name(s) first')),
                    );
                    return;
                  }
                  context.read<BuilderManagerCubit>().publishFunnel(
                        pages: builderCubit.state.pages,
                        funnelId: funnelId,
                        isLink: true,
                      );
                },
              ),
              SizedBox(width: 24),
              BuilderActionButton(
                label: 'Save',
                loading: state.saveStatus.isLoading,
                onTap: () {
                  if (builderCubit.state.invalidAnalyticsFieldPositions.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please add analytics field name(s) first')),
                    );
                    return;
                  }
                  context.read<BuilderManagerCubit>().publishFunnel(
                        pages: builderCubit.state.pages,
                        funnelId: funnelId,
                      );
                },
                isPrimary: true,
              ),
            ],
          ),
        );
      },
    );
  }

  popFunction(BuildContext context) {
    log('exiting');
    if (context.router.canPop()) {
      context.router.pop();
    } else {
      context.router.replace(const MyFunnelsRoute());
    }
  }
}
