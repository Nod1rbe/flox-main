import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/logger.dart';
import 'package:flox/feature/builder/blocs/builder_bloc/builder_cubit.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/cubit/button_view_cubit.dart';
import 'package:flox/feature/builder/configs/image_config/cubit/image_view_cubit.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/cubit/multiple_choice_view_cubit.dart';
import 'package:flox/feature/builder/configs/payment_config/cubit/payment_view_cubit.dart';
import 'package:flox/feature/builder/configs/progress_config/cubit/progress_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_config/cubit/text_view_cubit.dart';
import 'package:flox/feature/builder/configs/text_field_config/cubit/text_field_view_cubit.dart';
import 'package:flox/feature/builder/ui/sections/analytics_fields_section.dart';
import 'package:flox/feature/builder/ui/sections/button_section.dart';
import 'package:flox/feature/builder/ui/sections/delete_config_section.dart';
import 'package:flox/feature/builder/ui/sections/image_properties_section.dart';
import 'package:flox/feature/builder/ui/sections/mc_default_style_section.dart';
import 'package:flox/feature/builder/ui/sections/mc_option_values_section.dart';
import 'package:flox/feature/builder/ui/sections/mc_selection_style_section.dart';
import 'package:flox/feature/builder/ui/sections/padding_properties_section.dart';
import 'package:flox/feature/builder/ui/sections/progress_section.dart';
import 'package:flox/feature/builder/ui/sections/progress_values_section.dart';
import 'package:flox/feature/builder/ui/sections/text_field_style_section.dart';
import 'package:flox/feature/builder/ui/sections/text_properties_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigsLayout extends StatefulWidget {
  const ConfigsLayout({super.key});

  @override
  State<ConfigsLayout> createState() => _ConfigsLayoutState();
}

class _ConfigsLayoutState extends State<ConfigsLayout> {
  late final BuilderCubit builderCubit = context.read<BuilderCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuilderCubit, BuilderState>(
      // buildWhen: (p, c) => p.selectedWidgetConfigIndex != c.selectedWidgetConfigIndex || p.navButtonCubit != c.navButtonCubit,
      builder: (context, state) {
        return Container(
          width: 370,
          height: double.infinity,
          color: AppColors.layoutBackground,
          child: state.selectedWidgetConfig == null || state.selectedWidgetConfigIndex == -1
              ? const SizedBox()
              : SingleChildScrollView(
                  child: Column(children: getConfigWidgets(state.selectedWidgetConfig, state, context)),
                ),
        );
      },
    );
  }

  List<Widget> getConfigWidgets(BaseConfig? selectedWidgetConfig, BuilderState state, BuildContext context) {
    if (selectedWidgetConfig == null) return [SizedBox()];
    final String configIndexKey = state.selectedWidgetConfigIndex.toString();

    appLog('Config ${builderCubit.state.currentCubit.hashCode}');

    switch (selectedWidgetConfig.type) {
      case ViewType.text:
        var textViewCubit = builderCubit.state.currentCubit as TextViewCubit;
        return [
          PaddingPropertiesSection(
            key: ValueKey('padding_${state.selectedWidgetConfigIndex}'),
            onPaddingChanged: textViewCubit.updatePadding,
            currentPadding: textViewCubit.state.config.padding,
          ),
          TextPropertiesSection(
            key: ValueKey('text_properties_$configIndexKey'),
            onColorChanged: textViewCubit.updateColor,
            onEmojiSelected: textViewCubit.updateLeadingIcon,
            onFontSizeChanged: textViewCubit.updateSize,
            onFontWeightChanged: textViewCubit.updateWeight,
            onTextChanged: textViewCubit.updateText,
            onFontChanged: textViewCubit.updateFontFamily,
            onTextAlignChanged: textViewCubit.updateAlignment,
            textConfig: textViewCubit.state.config,
          ),
          DeleteConfigSection(),
        ];
      case ViewType.image:
        var imageViewCubit = builderCubit.state.currentCubit as ImageViewCubit;
        return [
          PaddingPropertiesSection(
            key: ValueKey('padding_${state.selectedWidgetConfigIndex}'),
            onPaddingChanged: imageViewCubit.updatePadding,
            currentPadding: imageViewCubit.state.config.padding,
          ),
          ImagePropertiesSection(
            key: ValueKey('image_properties_$configIndexKey'),
            onFitChanged: imageViewCubit.updateFit,
            onImageChanged: imageViewCubit.updateImageUrl,
            onAlignmentChanged: imageViewCubit.updateAlignment,
            onHeightChanged: imageViewCubit.updateHeight,
            onWidthChanged: imageViewCubit.updateWidth,
            onCornerRadiusChanged: imageViewCubit.updateCornerRadius,
            imageConfig: imageViewCubit.state.config,
          ),
          DeleteConfigSection(),
        ];
      case ViewType.textField:
        var textFieldViewCubit = builderCubit.state.currentCubit as TextFieldViewCubit;
        final String fieldName = textFieldViewCubit.state.config.analyticsFieldName;
        return [
          AnalyticsFieldsSection(
            key: ValueKey('text_field_analytics_fields_$configIndexKey'),
            onAnalyticsFieldChanged: textFieldViewCubit.updateAnalyticsFieldsName,
            value: fieldName,
          ),
          PaddingPropertiesSection(
            key: ValueKey('padding_${state.selectedWidgetConfigIndex}'),
            onPaddingChanged: textFieldViewCubit.updatePadding,
            currentPadding: textFieldViewCubit.state.config.padding,
          ),
          TextFieldStyleSection(
            key: ValueKey('text_field_style_$configIndexKey'),
            onHintTextChanged: textFieldViewCubit.updateHint,
            onCornerRadiusChanged: textFieldViewCubit.updateCornerRadius,
            onAlignmentChanged: textFieldViewCubit.updateAlignment,
            onTextColorChanged: textFieldViewCubit.updateTextColor,
            onBackgroundColorChanged: textFieldViewCubit.updateBackgroundColor,
            onFontWeightChanged: textFieldViewCubit.updateFontWeight,
            onFontSizeChanged: textFieldViewCubit.updateFontSize,
            onFontFamilyChanged: textFieldViewCubit.updateFontFamily,
            config: textFieldViewCubit.state.config,
          ),
          DeleteConfigSection(),
        ];
      case ViewType.button:
        var buttonViewCubit = builderCubit.state.navButtonCubit as ButtonViewCubit;
        return [
          PaddingPropertiesSection(
            key: ValueKey('padding_${state.selectedWidgetConfigIndex}'),
            onPaddingChanged: buttonViewCubit.updatePadding,
            currentPadding: buttonViewCubit.state.config.padding,
          ),
          ButtonSection(
            key: ValueKey('button_properties_$configIndexKey'),
            onTextChanged: buttonViewCubit.updateText,
            onButtonColorChanged: buttonViewCubit.updateButtonColor,
            onTextColorChanged: buttonViewCubit.updateTextColor,
            onRadiusChanged: buttonViewCubit.updateRadius,
            onWidthChanged: buttonViewCubit.updateWidth,
            onHeightChanged: buttonViewCubit.updateHeight,
            onTextSizeChanged: buttonViewCubit.updateTextSize,
            onFontWeightChanged: buttonViewCubit.updateTextWeight,
            onFontFamilyChanged: buttonViewCubit.updateFontFamily,
            onAlignmentChanged: buttonViewCubit.updateAlignment,
            buttonConfig: buttonViewCubit.state.config,
          ),
          DeleteConfigSection(),
        ];
      case ViewType.progress:
        var progressViewCubit = builderCubit.state.currentCubit as ProgressViewCubit;
        return [
          PaddingPropertiesSection(
            onPaddingChanged: progressViewCubit.updatePadding,
            currentPadding: progressViewCubit.state.config.padding,
            key: ValueKey('padding_${state.selectedWidgetConfigIndex}'),
          ),
          ProgressSection(
            key: ValueKey('progress_properties_$configIndexKey'),
            config: progressViewCubit.state.config,
            onBackgroundColorChanged: progressViewCubit.updateBackgroundColor,
            onHeightChanged: progressViewCubit.updateHeight,
            onRadiusChanged: progressViewCubit.updateCornerRadius,
            onShowIconsChanged: progressViewCubit.updateShowIcon,
            onTextColorChanged: progressViewCubit.updateTextColor,
            onTextFontSizeChanged: progressViewCubit.updateFontSize,
            onFontWeightChanged: progressViewCubit.updateFontWeight,
            onFontFamilyChanged: progressViewCubit.updateFontFamily,
          ),
          BlocProvider<ProgressViewCubit>.value(
            value: progressViewCubit,
            child: ProgressValuesSection(
              key: ValueKey('progress_values_$configIndexKey'),
              onAddProgressValue: progressViewCubit.addProgressValue,
              onProgressValueUpdated: progressViewCubit.updateProgressValue,
              onProgressValueRemoved: progressViewCubit.removeProgressValue,
            ),
          ),
          DeleteConfigSection(),
        ];
      case ViewType.multipleChoice:
        var mcViewCubit = builderCubit.state.currentCubit as MultipleChoiceViewCubit;
        final String fieldName = mcViewCubit.state.config.analyticsFieldName;
        return [
          AnalyticsFieldsSection(
            key: ValueKey('multiple_choice_analytics_fields_$configIndexKey'),
            onAnalyticsFieldChanged: mcViewCubit.updateAnalyticsFieldsName,
            value: fieldName,
          ),
          PaddingPropertiesSection(
              onPaddingChanged: mcViewCubit.updatePadding,
              currentPadding: mcViewCubit.state.config.padding,
              key: ValueKey('padding_${state.selectedWidgetConfigIndex}')),
          McDefaultStyleSection(
            key: ValueKey('mc_default_style_$configIndexKey'),
            onMultiSelectionChanged: mcViewCubit.updateMultiSelection,
            onShowIconsChanged: mcViewCubit.updateShowIcons,
            onCornerRadiusChanged: mcViewCubit.updateCornerRadius,
            onAlignmentChanged: mcViewCubit.updateAlignment,
            onTextColorChanged: mcViewCubit.updateTextColor,
            onBackgroundColorChanged: mcViewCubit.updateBackgroundColor,
            onFontWeightChanged: mcViewCubit.updateFontWeight,
            onFontSizeChanged: mcViewCubit.updateFontSize,
            onFontFamilyChanged: mcViewCubit.updateFontFamily,
            config: mcViewCubit.state.config.defaultStyle,
          ),
          McSelectionStyleSection(
            key: ValueKey('mc_selection_style_$configIndexKey'),
            onTextColorChanged: mcViewCubit.updateSelectedTextColor,
            onBackgroundColorChanged: mcViewCubit.updateSelectedBackgroundColor,
            onFontWeightChanged: mcViewCubit.updateSelectedFontWeight,
            onFontSizeChanged: mcViewCubit.updateSelectedFontSize,
            onFontFamilyChanged: mcViewCubit.updateSelectedFontFamily,
            config: mcViewCubit.state.config.selectedStyle,
          ),
          McOptionValuesSection(
            key: ValueKey('multiple_choice_options_$configIndexKey'),
            onAddOption: mcViewCubit.addOption,
            onOptionUpdated: mcViewCubit.updateOption,
            onOptionRemoved: mcViewCubit.removeOption,
            optionValues: mcViewCubit.state.config.optionValues,
          ),
          DeleteConfigSection(),
        ];
      case ViewType.payment:
        var paymentViewCubit = builderCubit.state.currentCubit as PaymentViewCubit;
        return [
          PaddingPropertiesSection(
            key: ValueKey('padding_${state.selectedWidgetConfigIndex}'),
            onPaddingChanged: paymentViewCubit.updatePadding,
            currentPadding: paymentViewCubit.state.config.padding,
          ),
          TextFieldStyleSection(
            key: ValueKey('text_field_style_$configIndexKey'),
            onHintTextChanged: paymentViewCubit.updateTextFieldHint,
            onCornerRadiusChanged: paymentViewCubit.updateTextFieldCornerRadius,
            onAlignmentChanged: paymentViewCubit.updateTextFieldAlignment,
            onTextColorChanged: paymentViewCubit.updateTextFieldTextColor,
            onBackgroundColorChanged: paymentViewCubit.updateTextFieldBackgroundColor,
            onFontWeightChanged: paymentViewCubit.updateTextFieldFontWeight,
            onFontSizeChanged: paymentViewCubit.updateTextFieldFontSize,
            onFontFamilyChanged: paymentViewCubit.updateTextFieldFontFamily,
            config: paymentViewCubit.state.config.textFieldConfig,
          ),
          ButtonSection(
            key: ValueKey('button_properties_$configIndexKey'),
            onTextChanged: paymentViewCubit.updateButtonText,
            onButtonColorChanged: paymentViewCubit.updateButtonColor,
            onTextColorChanged: paymentViewCubit.updateButtonTextColor,
            onRadiusChanged: paymentViewCubit.updateButtonRadius,
            onWidthChanged: paymentViewCubit.updateButtonWidth,
            onHeightChanged: paymentViewCubit.updateButtonHeight,
            onTextSizeChanged: paymentViewCubit.updateButtonTextSize,
            onFontWeightChanged: paymentViewCubit.updateButtonTextWeight,
            onFontFamilyChanged: paymentViewCubit.updateButtonFontFamily,
            onAlignmentChanged: paymentViewCubit.updateButtonAlignment,
            buttonConfig: paymentViewCubit.state.config.buttonConfig,
          ),
          DeleteConfigSection(),
        ];
    }
  }
}
