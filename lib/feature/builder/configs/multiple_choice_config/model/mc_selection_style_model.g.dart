// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mc_selection_style_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McSelectionStyleModel _$McSelectionStyleModelFromJson(
        Map<String, dynamic> json) =>
    McSelectionStyleModel(
      textColor: json['tC'] as String?,
      backgroundColor: json['bgC'] as String?,
      fontWeight: (json['fW'] as num?)?.toInt(),
      fontSize: (json['fS'] as num?)?.toDouble(),
      fontFamily: json['fF'] as String?,
    );

Map<String, dynamic> _$McSelectionStyleModelToJson(
        McSelectionStyleModel instance) =>
    <String, dynamic>{
      'tC': instance.textColor,
      'bgC': instance.backgroundColor,
      'fW': instance.fontWeight,
      'fS': instance.fontSize,
      'fF': instance.fontFamily,
    };
