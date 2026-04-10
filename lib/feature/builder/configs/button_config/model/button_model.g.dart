// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtonModel _$ButtonModelFromJson(Map<String, dynamic> json) => ButtonModel(
      buttonColor: json['c'] as String?,
      textColor: json['tc'] as String?,
      text: json['t'] as String?,
      radius: (json['r'] as num?)?.toDouble(),
      padding: json['padding'] == null
          ? null
          : PaddingModel.fromJson(json['padding'] as Map<String, dynamic>),
      width: (json['w'] as num?)?.toDouble(),
      height: (json['h'] as num?)?.toDouble(),
      textSize: (json['ts'] as num?)?.toDouble(),
      textWeight: (json['tw'] as num?)?.toInt(),
      alignment: json['a'] as String?,
      fontFamily: json['fF'] as String?,
    )..type = json['type'] as String;

Map<String, dynamic> _$ButtonModelToJson(ButtonModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'c': instance.buttonColor,
      'tc': instance.textColor,
      't': instance.text,
      'ts': instance.textSize,
      'tw': instance.textWeight,
      'r': instance.radius,
      'padding': instance.padding,
      'w': instance.width,
      'h': instance.height,
      'a': instance.alignment,
      'fF': instance.fontFamily,
    };
