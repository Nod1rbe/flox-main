// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextModel _$TextModelFromJson(Map<String, dynamic> json) => TextModel(
      text: json['t'] as String?,
      color: json['c'] as String?,
      size: (json['s'] as num?)?.toDouble(),
      alignment: json['a'] as String?,
      weight: (json['w'] as num?)?.toInt(),
      fontFamily: json['fF'] as String?,
      padding: json['padding'] == null
          ? null
          : PaddingModel.fromJson(json['padding'] as Map<String, dynamic>),
      leadingIcon: json['lI'] as String?,
    )..type = json['type'] as String;

Map<String, dynamic> _$TextModelToJson(TextModel instance) => <String, dynamic>{
      'type': instance.type,
      't': instance.text,
      'c': instance.color,
      's': instance.size,
      'a': instance.alignment,
      'w': instance.weight,
      'fF': instance.fontFamily,
      'lI': instance.leadingIcon,
      'padding': instance.padding,
    };
