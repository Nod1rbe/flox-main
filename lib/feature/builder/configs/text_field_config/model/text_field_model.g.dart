// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextFieldModel _$TextFieldModelFromJson(Map<String, dynamic> json) =>
    TextFieldModel(
      hintText: json['hT'] as String?,
      analyticsFieldsName: json['aFn'] as String?,
      padding: json['padding'] == null
          ? null
          : PaddingModel.fromJson(json['padding'] as Map<String, dynamic>),
      cornerRadius: (json['cR'] as num?)?.toDouble(),
      alignment: json['a'] as String?,
      textColor: json['tC'] as String?,
      backgroundColor: json['bgC'] as String?,
      fontWeight: (json['fW'] as num?)?.toInt(),
      fontSize: (json['fS'] as num?)?.toDouble(),
      fontFamily: json['fF'] as String?,
    )..type = json['type'] as String;

Map<String, dynamic> _$TextFieldModelToJson(TextFieldModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'padding': instance.padding,
      'hT': instance.hintText,
      'cR': instance.cornerRadius,
      'a': instance.alignment,
      'tC': instance.textColor,
      'bgC': instance.backgroundColor,
      'fW': instance.fontWeight,
      'fS': instance.fontSize,
      'fF': instance.fontFamily,
      'aFn': instance.analyticsFieldsName,
    };
