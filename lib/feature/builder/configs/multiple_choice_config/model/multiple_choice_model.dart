import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_default_style_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_option_values_model.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_selection_style_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'multiple_choice_model.g.dart';

@JsonSerializable()
class MultipleChoiceModel implements BaseConfigModel {
  @override
  String type;

  @JsonKey(name: 'd')
  final McDefaultStyleModel? defaultStyle;

  @JsonKey(name: 's')
  final McSelectionStyleModel? selectionStyle;

  @JsonKey(name: 'o')
  final List<McOptionValuesModel>? optionValues;

  @JsonKey(name: 'padding')
  final PaddingModel? padding;

  @JsonKey(name: 'aFn')
  final String? analyticsFieldsName;

  MultipleChoiceModel(
      {this.defaultStyle, this.selectionStyle, this.optionValues, this.padding, this.analyticsFieldsName})
      : type = ViewType.multipleChoice.name;

  factory MultipleChoiceModel.fromJson(Map<String, dynamic> json) => _$MultipleChoiceModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MultipleChoiceModelToJson(this);

  factory MultipleChoiceModel.sample() => MultipleChoiceModel(
        padding: PaddingModel.sample,
        defaultStyle: McDefaultStyleModel.sample(),
        selectionStyle: McSelectionStyleModel.sample(),
        optionValues: [McOptionValuesModel.sample1(), McOptionValuesModel.sample2(), McOptionValuesModel.sample3()],
      );
}
