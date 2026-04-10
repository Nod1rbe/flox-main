import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'gradient_settings_model.dart';

part 'page_settings_model.g.dart';

@JsonSerializable()
class PageSettingsModel {
  @JsonKey(name: 'bgI')
  final String? backgroundImage;

  @JsonKey(name: 'gS')
  final GradientSettingsModel? gradientSettings;

  @JsonKey(name: 's')
  final bool? scrollable;

  @JsonKey(name: 'bgC')
  final String? backgroundColor;

  @JsonKey(name: 'aN')
  final bool? autoNavigation;

  @JsonKey(name: 'dS')
  final double? durationInSeconds;

  PageSettingsModel({
    this.backgroundImage,
    this.gradientSettings,
    this.scrollable,
    this.backgroundColor,
    this.autoNavigation,
    this.durationInSeconds,
  });

  factory PageSettingsModel.fromJson(Map<String, dynamic> json) => _$PageSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageSettingsModelToJson(this);

  factory PageSettingsModel.sample() => PageSettingsModel(
        backgroundImage: '',
        gradientSettings: null,
        scrollable: true,
        backgroundColor: Colors.white.toHexString(),
        autoNavigation: false,
        durationInSeconds: 0,
      );
}
