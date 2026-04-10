import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_field_model.g.dart';

@JsonSerializable()
class TextFieldModel implements BaseConfigModel {
  @override
  String type;

  @JsonKey(name: 'padding')
  final PaddingModel? padding;

  @JsonKey(name: 'hT')
  final String? hintText;

  @JsonKey(name: 'cR')
  final double? cornerRadius;

  @JsonKey(name: 'a')
  final String? alignment;

  @JsonKey(name: 'tC')
  final String? textColor;

  @JsonKey(name: 'bgC')
  final String? backgroundColor;

  @JsonKey(name: 'fW')
  final int? fontWeight;

  @JsonKey(name: 'fS')
  final double? fontSize;

  @JsonKey(name: 'aFn')
  final String? analyticsFieldsName;

  @JsonKey(name: 'fF')
  final String? fontFamily;

  TextFieldModel({
    this.hintText,
    this.analyticsFieldsName,
    this.padding,
    this.cornerRadius,
    this.alignment,
    this.textColor,
    this.backgroundColor,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
  }) : type = ViewType.textField.name;

  factory TextFieldModel.fromJson(Map<String, dynamic> json) => _$TextFieldModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextFieldModelToJson(this);

  factory TextFieldModel.sample() => TextFieldModel(
        padding: PaddingModel.sample,
        analyticsFieldsName: 'sample',
        hintText: 'Enter text',
        cornerRadius: 8,
        alignment: 'center',
        textColor: '000000',
        backgroundColor: 'F5F5F5',
        fontWeight: 400,
        fontSize: 16,
        fontFamily: 'Inter',
      );
}
