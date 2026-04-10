import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_values_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'progress_model.g.dart';

@JsonSerializable()
class ProgressModel implements BaseConfigModel {
  @override
  String type;

  @JsonKey(name: 'padding')
  final PaddingModel? padding;

  @JsonKey(name: 'h')
  final double? height;

  @JsonKey(name: 'cR')
  final double? cornerRadius;

  @JsonKey(name: 'shI')
  final bool? showIcon;

  @JsonKey(name: 'tC')
  final String? textColor;

  @JsonKey(name: 'bgC')
  final String? backgroundColor;

  @JsonKey(name: 'fW')
  final int? fontWeight;

  @JsonKey(name: 'fS')
  final double? fontSize;

  @JsonKey(name: 'fF')
  final String? fontFamily;

  @JsonKey(name: 'progV')
  final List<ProgressValuesModel>? progressValues;

  ProgressModel({
    this.padding,
    this.height,
    this.cornerRadius,
    this.showIcon,
    this.textColor,
    this.backgroundColor,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
    this.progressValues,
  }) : type = ViewType.progress.name;

  factory ProgressModel.fromJson(Map<String, dynamic> json) => _$ProgressModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProgressModelToJson(this);

  factory ProgressModel.sample() => ProgressModel(
        padding: PaddingModel.sample,
        height: 14,
        cornerRadius: 24,
        showIcon: false,
        textColor: 'FFFFFF',
        backgroundColor: 'F5F5F5',
        fontWeight: 400,
        fontSize: 14,
        fontFamily: 'Inter',
        progressValues: [ProgressValuesModel.sample1()],
      );
}
