import 'package:cached_network_image/cached_network_image.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/enums/ui_enums/main_navigation_enum.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/feature/main_dashboard/settings/settings_cubit/settings_cubit.dart';
import 'package:flox/ui_components/components/tappable_component.dart';
import 'package:flox/ui_components/elements/shimmer_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationAccountItem extends StatelessWidget {
  final double sideBarWidth;

  const NavigationAccountItem({
    super.key,
    required this.sideBarWidth,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          previous.logoutStatus != current.logoutStatus || previous.getUserDataStatus != current.getUserDataStatus,
      buildWhen: (previous, current) =>
          previous.logoutStatus != current.logoutStatus || previous.getUserDataStatus != current.getUserDataStatus,
      listener: (context, state) {
        if (state.logoutStatus.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Container(
          height: 70,
          width: sideBarWidth,
          color: AppColors.fillColor,
          child: Row(
            children: [
              const SizedBox(width: 16),
              ShimmerElement(
                isLoading: state.getUserDataStatus.isLoading,
                height: 40,
                width: 40,
                radius: 100,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: state.userData.imageUrl == null || state.userData.imageUrl!.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: MainNavigationEnum.values.last.icon.svg(
                            colorFilter: ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: state.userData.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerElement(
                      isLoading: state.getUserDataStatus.isLoading,
                      height: 16,
                      width: 100,
                      radius: 6,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        child: Text(state.userData.name ?? 'Anonymous'),
                      ),
                    ),
                    const SizedBox(height: 2),
                    ShimmerElement(
                      isLoading: state.getUserDataStatus.isLoading,
                      height: 16,
                      width: double.infinity,
                      radius: 6,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.subtitle,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        child: Text(state.userData.email ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 38,
                width: 38,
                child: TappableComponent(
                  onTap: () {
                    context.read<SettingsCubit>().logout();
                  },
                  borderRadius: 8,
                  hoverColor: AppColors.defaultSplashColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: state.logoutStatus.isLoading
                        ? CupertinoActivityIndicator(color: AppColors.white)
                        : Assets.icons.logout.svg(),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        );
      },
    );
  }
}
