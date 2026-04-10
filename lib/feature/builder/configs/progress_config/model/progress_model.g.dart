// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressModel _$ProgressModelFromJson(Map<String, dynamic> json) =>
    ProgressModel(
      padding: json['padding'] == null
          ? null
          : PaddingModel.fromJson(json['padding'] as Map<String, dynamic>),
      height: (json['h'] as num?)?.toDouble(),
      cornerRadius: (json['cR'] as num?)?.toDouble(),
      showIcon: json['shI'] as bool?,
      textColor: json['tC'] as String?,
      backgroundColor: json['bgC'] as String?,
      fontWeight: (json['fW'] as num?)?.toInt(),
      fontSize: (json['fS'] as num?)?.toDouble(),
      fontFamily: json['fF'] as String?,
      progressValues: (json['progV'] as List<dynamic>?)
          ?.map((e) => ProgressValuesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..type = json['type'] as String;

Map<String, dynamic> _$ProgressModelToJson(ProgressModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'padding': instance.padding,
      'h': instance.height,
      'cR': instance.cornerRadius,
      'shI': instance.showIcon,
      'tC': instance.textColor,
      'bgC': instance.backgroundColor,
      'fW': instance.fontWeight,
      'fS': instance.fontSize,
      'fF': instance.fontFamily,
      'progV': instance.progressValues,
    };
