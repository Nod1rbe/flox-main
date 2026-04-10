import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_model.g.dart';

@JsonSerializable()
class TextModel implements BaseConfigModel {
  @override
  String type;

  @JsonKey(name: 't')
  final String? text;

  @JsonKey(name: 'c')
  final String? color;

  @JsonKey(name: 's')
  final double? size;

  @JsonKey(name: 'a')
  final String? alignment;

  @JsonKey(name: 'w')
  final int? weight;

  @JsonKey(name: 'fF')
  final String? fontFamily;

  @JsonKey(name: 'lI')
  final String? leadingIcon;

  @JsonKey(name: 'padding')
  final PaddingModel? padding;

  TextModel({
    this.text,
    this.color,
    this.size,
    this.alignment,
    this.weight,
    this.fontFamily,
    this.padding,
    this.leadingIcon,
  }) : type = ViewType.text.name;

  factory TextModel.fromJson(Map<String, dynamic> json) => _$TextModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextModelToJson(this);

  factory TextModel.sample() => TextModel(
        text: 'Sample Text',
        color: '000000',
        size: 24.0,
        alignment: 'center',
        weight: 700,
        fontFamily: 'Inter',
        padding: PaddingModel(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        leadingIcon: '',
      );
}
