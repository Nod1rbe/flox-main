import 'package:json_annotation/json_annotation.dart';

part 'gradient_settings_model.g.dart';

@JsonSerializable()
class GradientSettingsModel {
  @JsonKey(name: 'gC')
  final List<String>? gradientColors;

  @JsonKey(name: 'gb')
  final String? begin;

  @JsonKey(name: 'ge')
  final String? end;

  GradientSettingsModel({
    this.gradientColors,
    this.begin,
    this.end,
  });

  factory GradientSettingsModel.fromJson(Map<String, dynamic> json) => _$GradientSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GradientSettingsModelToJson(this);

  factory GradientSettingsModel.sample() => GradientSettingsModel(
        gradientColors: null,
        begin: 'topCenter',
        end: 'bottomCenter',
      );
}
