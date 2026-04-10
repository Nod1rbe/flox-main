import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'button_model.g.dart';

@JsonSerializable()
class ButtonModel implements BaseConfigModel {
  @override
  String type;

  @JsonKey(name: 'c')
  final String? buttonColor;

  @JsonKey(name: 'tc')
  final String? textColor;

  @JsonKey(name: 't')
  final String? text;

  @JsonKey(name: 'ts')
  final double? textSize;

  @JsonKey(name: 'tw')
  final int? textWeight;

  @JsonKey(name: 'r')
  final double? radius;

  @JsonKey(name: 'padding')
  final PaddingModel? padding;

  @JsonKey(name: 'w')
  final double? width;

  @JsonKey(name: 'h')
  final double? height;

  @JsonKey(name: 'a')
  final String? alignment;

  @JsonKey(name: 'fF')
  final String? fontFamily;

  ButtonModel({
    this.buttonColor,
    this.textColor,
    this.text,
    this.radius,
    this.padding,
    this.width,
    this.height,
    this.textSize,
    this.textWeight,
    this.alignment,
    this.fontFamily,
  }) : type = ViewType.button.name;

  factory ButtonModel.fromJson(Map<String, dynamic> json) => _$ButtonModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ButtonModelToJson(this);

  factory ButtonModel.sample() => ButtonModel(
        buttonColor: '000000',
        textColor: 'FFFFFF',
        text: 'Continue',
        radius: 16,
        padding: PaddingModel(top: 8, bottom: 8, left: 16, right: 16),
        width: 200,
        height: 50,
        alignment: 'center',
        textSize: 14,
        textWeight: 500,
        fontFamily: 'Inter',
      );
}
