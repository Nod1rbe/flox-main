// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mc_default_style_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McDefaultStyleModel _$McDefaultStyleModelFromJson(Map<String, dynamic> json) =>
    McDefaultStyleModel(
      multiSelection: json['mL'] as bool?,
      showIcon: json['shI'] as bool?,
      cornerRadius: (json['cR'] as num?)?.toDouble(),
      alignment: json['a'] as String?,
      textColor: json['tC'] as String?,
      backgroundColor: json['bgC'] as String?,
      fontWeight: (json['fW'] as num?)?.toInt(),
      fontSize: (json['fS'] as num?)?.toDouble(),
      fontFamily: json['fF'] as String?,
    );

Map<String, dynamic> _$McDefaultStyleModelToJson(
        McDefaultStyleModel instance) =>
    <String, dynamic>{
      'mL': instance.multiSelection,
      'shI': instance.showIcon,
      'cR': instance.cornerRadius,
      'a': instance.alignment,
      'tC': instance.textColor,
      'bgC': instance.backgroundColor,
      'fW': instance.fontWeight,
      'fS': instance.fontSize,
      'fF': instance.fontFamily,
    };
