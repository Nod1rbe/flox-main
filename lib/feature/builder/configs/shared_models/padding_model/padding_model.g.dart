// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'padding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaddingModel _$PaddingModelFromJson(Map<String, dynamic> json) => PaddingModel(
      left: (json['l'] as num).toDouble(),
      right: (json['r'] as num).toDouble(),
      top: (json['t'] as num).toDouble(),
      bottom: (json['b'] as num).toDouble(),
    );

Map<String, dynamic> _$PaddingModelToJson(PaddingModel instance) =>
    <String, dynamic>{
      'l': instance.left,
      'r': instance.right,
      't': instance.top,
      'b': instance.bottom,
    };
