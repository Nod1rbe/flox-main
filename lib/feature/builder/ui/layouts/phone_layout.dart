import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/core/extensions/logger.dart';
import 'package:flox/core/gen/assets.gen.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/cubit/button_view_cubit.dart';
import 'package:flox/feature/builder/configs/image_config/cubit/image_view_cubit.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/cubit/multiple_choice_view_cubit.dart';
import 'package:flox/feature/builder/configs/payment_config/cubit/payment_view_cubit.dart';
import 'package:flox/feature/builder/configs/progress_config/cubit/progress_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_config/cubit/text_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_field_config/cubit/text_field_view_cubit.dart';
import 'package:flox/ui_components/elements/shimmer_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneScreenLayout extends StatelessWidget {
  final bool loading;

  const PhoneScreenLayout({super.key, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuilderCubit, BuilderState>(
      builder: (context, state) {
        debugPrint("PhoneScreenLayout rebuilt");
        final pageSettings = state.selectedPage.pageSettingsConfig;
        final gradientColors = pageSettings.gradientSettings?.gradientColors ?? [];
        final hasGradient = gradientColors.isNotEmpty;
        ImageProvider? imageProvider;

        if (pageSettings.backgroundImage.startsWith('http')) {
          imageProvider = CachedNetworkImageProvider(pageSettings.backgroundImage);
        } else if (pageSettings.backgroundImage.isNotEmpty && File(pageSettings.backgroundImage).existsSync()) {
          imageProvider = FileImage(File(pageSettings.backgroundImage));
        }

        return Center(
          child: Container(
            height: 600,
            width: 285,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(48)),
            foregroundDecoration: BoxDecoration(
              border: Border.all(color: AppColors.black, width: 4, strokeAlign: BorderSide.strokeAlignOutside),
              borderRadius: BorderRadius.circular(48),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48),
                ),
                child: ShimmerElement(
                  isLoading: loading,
                  height: 600,
                  width: 285,
                  radius: 48,
                  child: Stack(
                    children: [
                      if (imageProvider != null)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: hasGradient ? null : (pageSettings.backgroundColor ?? Colors.white),
                            gradient: hasGradient
                                ? LinearGradient(
                                    colors: gradientColors.map((color) => color.toColor).toList(),
                                    begin: _getAlignment(pageSettings.gradientSettings!.begin ?? 'topCenter'),
                                    end: _getAlignment(pageSettings.gradientSettings!.end ?? 'bottomCenter'),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          Assets.img.island.image(),
                          Expanded(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: AppColors.transparent,
                                shadowColor: AppColors.transparent,
                              ),
                              child: ReorderableListView(
                                physics: pageSettings.scrollable
                                    ? const BouncingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                buildDefaultDragHandles: false,
                                primary: true,
                                onReorder: (oldIndex, newIndex) {
                                  context.read<BuilderCubit>().reorderComponent(
                                        oldIndex: oldIndex,
                                        newIndex: newIndex,
                                      );
                                },
                                children: List.generate(
                                  state.selectedPage.configs.length,
                                  (index) {
                                    final BaseConfig config = state.selectedPage.configs[index];
                                    final key = ValueKey('${config.hashCode}$config');
                                    return _customInkwell(
                                      key: key,
                                      onTap: () {
                                        context.read<BuilderCubit>().componentSelected(
                                              config: config,
                                              index: index,
                                            );
                                      },
                                      child: ReorderableDragStartListener(
                                        index: index,
                                        key: key,
                                        child: getCubitProviders(
                                          config: config,
                                          index: index,
                                          state: state,
                                          key: key,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (!state.selectedPage.pageSettingsConfig.autoNavigate)
                            _customInkwell(
                              key: ValueKey(state.selectedPage.navButton.toString()),
                              onTap: () {
                                context.read<BuilderCubit>().componentSelected(
                                      config: state.selectedPage.navButton,
                                      index: -9,
                                    );
                              },
                              child: getCubitProviders(config: state.selectedPage.navButton, index: -9, state: state),
                            ),
                          Container(
                            height: 3,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.pageBackground,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Alignment _getAlignment(String alignment) {
    switch (alignment) {
      case 'topCenter':
        return Alignment.topCenter;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'center':
        return Alignment.center;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      default:
        return Alignment.topCenter;
    }
  }

  BlocProvider getCubitProviders({
    required BaseConfig config,
    required int index,
    required BuilderState state,
    Key? key,
  }) {
    switch (config.type) {
      case ViewType.text:
        var cubit = state.viewCubits?[index] as TextViewCubit;
        appLog(cubit.hashCode);
        return BlocProvider<TextViewCubit>(
          key: key,
          create: (context) => cubit,
          child: config.toWidget(index == state.selectedWidgetConfigIndex),
        );
      case ViewType.image:
        var cubit = state.viewCubits?[index] as ImageViewCubit;
        return BlocProvider<ImageViewCubit>(
          key: key,
          create: (context) => cubit,
          child: config.toWidget(index == state.selectedWidgetConfigIndex),
        );
      case ViewType.button:
        var cubit = state.navButtonCubit as ButtonViewCubit;
        return BlocProvider<ButtonViewCubit>(
          key: key,
          create: (context) => cubit,
          child: config.toWidget(-9 == state.selectedWidgetConfigIndex, key: ValueKey(cubit.hashCode)),
        );
      case ViewType.textField:
        var cubit = state.viewCubits?[index] as TextFieldViewCubit;
        return BlocProvider<TextFieldViewCubit>(
          key: key,
          create: (context) => cubit,
          child: config.toWidget(index == state.selectedWidgetConfigIndex),
        );
      case ViewType.progress:
        var cubit = state.viewCubits?[index] as ProgressViewCubit;
        return BlocProvider<ProgressViewCubit>(
          key: key,
          create: (context) => cubit,
          child: config.toWidget(index == state.selectedWidgetConfigIndex),
        );
      case ViewType.multipleChoice:
        var cubit = state.viewCubits?[index] as MultipleChoiceViewCubit;
        return BlocProvider<MultipleChoiceViewCubit>(
          key: key,
          create: (context) => cubit,
          child: config.toWidget(index == state.selectedWidgetConfigIndex),
        );
      case ViewType.payment:
        var cubit = state.viewCubits?[index] as PaymentViewCubit;
        return BlocProvider<PaymentViewCubit>(
          key: key,
          create: (context) => cubit,
          child: config.toWidget(index == state.selectedWidgetConfigIndex),
        );
    }
  }

  Widget _customInkwell({
    required Widget child,
    required Function() onTap,
    Key? key,
  }) {
    return InkWell(
      focusColor: AppColors.transparent,
      hoverColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      splashColor: AppColors.transparent,
      key: key,
      onTap: onTap,
      child: child,
    );
  }
}
