// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageSettingsModel _$PageSettingsModelFromJson(Map<String, dynamic> json) =>
    PageSettingsModel(
      backgroundImage: json['bgI'] as String?,
      gradientSettings: json['gS'] == null
          ? null
          : GradientSettingsModel.fromJson(json['gS'] as Map<String, dynamic>),
      scrollable: json['s'] as bool?,
      backgroundColor: json['bgC'] as String?,
      autoNavigation: json['aN'] as bool?,
      durationInSeconds: (json['dS'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PageSettingsModelToJson(PageSettingsModel instance) =>
    <String, dynamic>{
      'bgI': instance.backgroundImage,
      'gS': instance.gradientSettings,
      's': instance.scrollable,
      'bgC': instance.backgroundColor,
      'aN': instance.autoNavigation,
      'dS': instance.durationInSeconds,
    };
