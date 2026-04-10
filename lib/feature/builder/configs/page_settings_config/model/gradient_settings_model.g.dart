// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradient_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradientSettingsModel _$GradientSettingsModelFromJson(
        Map<String, dynamic> json) =>
    GradientSettingsModel(
      gradientColors:
          (json['gC'] as List<dynamic>?)?.map((e) => e as String).toList(),
      begin: json['gb'] as String?,
      end: json['ge'] as String?,
    );

Map<String, dynamic> _$GradientSettingsModelToJson(
        GradientSettingsModel instance) =>
    <String, dynamic>{
      'gC': instance.gradientColors,
      'gb': instance.begin,
      'ge': instance.end,
    };
