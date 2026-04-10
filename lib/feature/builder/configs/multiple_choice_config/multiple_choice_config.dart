import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/mc_default_style_config.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/mc_option_values_config.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/mc_selected_style_config.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_default_style_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_selection_style_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/multiple_choice_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/multiple_choice_config_widget.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flutter/cupertino.dart';

class MultipleChoiceConfig extends BaseConfig {
  final McDefaultStyleConfig defaultStyle;
  final McSelectedStyleConfig selectedStyle;
  final String analyticsFieldName;
  final List<McOptionValuesConfig> optionValues;

  MultipleChoiceConfig({
    required this.analyticsFieldName,
    required super.padding,
    required this.defaultStyle,
    required this.selectedStyle,
    required this.optionValues,
  }) : super(type: ViewType.multipleChoice);

  factory MultipleChoiceConfig.fromModel(MultipleChoiceModel model) {
    return MultipleChoiceConfig(
      analyticsFieldName: model.analyticsFieldsName ?? '',
      defaultStyle: McDefaultStyleConfig.fromModel(model.defaultStyle ?? McDefaultStyleModel.sample()),
      selectedStyle: McSelectedStyleConfig.fromModel(model.selectionStyle ?? McSelectionStyleModel.sample()),
      optionValues: model.optionValues?.map((e) => McOptionValuesConfig.fromModel(e)).toList() ?? [],
      padding: EdgeInsets.zero.fromPaddingModel(model.padding),
    );
  }

  @override
  Widget toWidget(bool isSelected, {Key? key}) {
    return MultipleChoiceConfigWidget(
      config: this,
      isSelected: isSelected,
      key: key,
    );
  }

  MultipleChoiceConfig copyWith({
    String? analyticsFieldsName,
    EdgeInsets? padding,
    McDefaultStyleConfig? defaultStyle,
    McSelectedStyleConfig? selectedStyle,
    List<McOptionValuesConfig>? optionValues,
  }) {
    return MultipleChoiceConfig(
      analyticsFieldName: analyticsFieldsName ?? this.analyticsFieldName,
      padding: padding ?? this.padding,
      defaultStyle: defaultStyle ?? this.defaultStyle,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      optionValues: optionValues ?? this.optionValues,
    );
  }

  @override
  MultipleChoiceModel toModel() {
    var padding = PaddingModel.fromEdgeInsets(this.padding);
    return MultipleChoiceModel(
      padding: padding,
      analyticsFieldsName: analyticsFieldName,
      defaultStyle: defaultStyle.toModel(),
      selectionStyle: selectedStyle.toModel(),
      optionValues: optionValues.map((e) => e.toModel()).toList(),
    );
  }

  @override
  String toString() {
    return 'MultipleChoiceConfig{padding: $padding, defaultStyle: $defaultStyle, selectedStyle: $selectedStyle, optionValues: $optionValues, analyticsFieldsName: $analyticsFieldName}';
  }
}
