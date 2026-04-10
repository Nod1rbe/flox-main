// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_values_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressValuesModel _$ProgressValuesModelFromJson(Map<String, dynamic> json) =>
    ProgressValuesModel(
      text: json['t'] as String?,
      duration: (json['d'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProgressValuesModelToJson(
        ProgressValuesModel instance) =>
    <String, dynamic>{
      't': instance.text,
      'd': instance.duration,
    };
