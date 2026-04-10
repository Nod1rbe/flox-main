import 'dart:developer';

import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/page_settings_config/model/gradient_settings_model.dart';
import 'package:flox/feature/builder/configs/page_settings_config/page_settings_config.dart';
import 'package:flox/ui_components/components/atoms/gradient_color_selector.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/molecules/switch_molecule.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../ui_components/components/molecules/color_picker_molecule.dart';
import '../../../main_dashboard/navigation/widgets/image_picker_dialog.dart';

class PageSettingsSection extends StatefulWidget {
  const PageSettingsSection({super.key});

  @override
  State<PageSettingsSection> createState() => _PageSettingsSectionState();
}

class _PageSettingsSectionState extends State<PageSettingsSection> {
  _showImagesDialog(BuildContext context) {
    final builderCubit = context.read<BuilderCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => ImagePickerDialog(
        onImageSelected: (imageUrl) {
          final updatedSettings =
              builderCubit.state.selectedPage.pageSettingsConfig.copyWith(backgroundImage: imageUrl);
          builderCubit.updatePageSettings(updatedSettings);
        },
        initialImageUrls: [builderCubit.state.selectedPage.pageSettingsConfig.backgroundImage],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuilderCubit, BuilderState>(
      buildWhen: (p, c) =>
          p.selectedPage != c.selectedPage ||
          p.selectedPage.pageSettingsConfig != c.selectedPage.pageSettingsConfig ||
          p.selectedPage.pageSettingsConfig.backgroundColor != c.selectedPage.pageSettingsConfig.backgroundColor ||
          p.selectedPage.pageSettingsConfig.gradientSettings != c.selectedPage.pageSettingsConfig.gradientSettings,
      builder: (context, state) {
        PageSettingsConfig pageSettings = state.selectedPage.pageSettingsConfig;
        log('Page ${state.selectedPage.pageOrder} - Settings: $pageSettings');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Styles', style: TextStyle(fontSize: 24, color: AppColors.white)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showImagesDialog(context),
                child: Container(
                  height: 48,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: AppColors.defaultButtonBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      TextAtom(
                        text: 'Background image',
                        textAlign: TextAlign.start,
                        fontSize: 16,
                      ),
                      const Spacer(),
                      if (pageSettings.backgroundImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            pageSettings.backgroundImage,
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.white.withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.only(left: 12, right: 5),
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.defaultButtonBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Scrollable',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, color: AppColors.white),
                    ),
                    Checkbox(
                      splashRadius: 0,
                      autofocus: true,
                      value: pageSettings.scrollable,
                      onChanged: (value) {
                        if (value != null) {
                          final updatedSettings = pageSettings.copyWith(scrollable: value);
                          context.read<BuilderCubit>().updatePageSettings(updatedSettings);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ColorPickerMolecule(
                initialColor: pageSettings.backgroundColor ?? Colors.transparent,
                onColorChanged: (value) {
                  final updatedSettings = pageSettings.copyWith(
                    backgroundColor: value,
                  );
                  context.read<BuilderCubit>().updatePageSettings(updatedSettings);
                },
                name: 'Background color',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF444444),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextAtom(
                      text: 'Gradient colors',
                      fontSize: 16,
                    ),
                    GradientSelectorAtom(
                      onDataChanged: (GradientSettingsModel newGradientSettings) {
                        final updatedSettings = pageSettings.copyWith(
                          gradientSettings: newGradientSettings,
                        );
                        context.read<BuilderCubit>().updatePageSettings(updatedSettings);
                      },
                      initialData: state.selectedPage.pageSettingsConfig.gradientSettings ??
                          GradientSettingsModel(
                            gradientColors: [Colors.blue.toHexString(), Colors.red.toHexString()],
                            begin: 'topCenter',
                            end: 'bottomCenter',
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.only(left: 10, right: 5, top: 12, bottom: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.defaultButtonBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SwitchMolecule(
                      key: ValueKey('autoNavigateSwitch${state.selectedPage.pageOrder}'),
                      name: 'Auto Navigation',
                      fontSize: 16,
                      initialValue: pageSettings.autoNavigate,
                      onChanged: (value) {
                        final updatedSettings = pageSettings.copyWith(autoNavigate: value);
                        context.read<BuilderCubit>().updatePageSettings(updatedSettings);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFieldWithLabelMolecule(
                      key: ValueKey('autoNavigateDuration${state.selectedPage.pageOrder}'),
                      name: 'Duration in sec',
                      padding: EdgeInsets.zero,
                      onChanged: (value) {
                        final duration = double.tryParse(value);
                        if (duration != null) {
                          final updatedSettings = pageSettings.copyWith(
                            duration: Duration(milliseconds: (duration * 1000).toInt()),
                          );
                          context.read<BuilderCubit>().updatePageSettings(updatedSettings);
                        }
                      },
                      currentValue: (pageSettings.duration.inMilliseconds / 1000.0).toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
