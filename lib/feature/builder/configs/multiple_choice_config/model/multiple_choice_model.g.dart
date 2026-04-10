// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_choice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleChoiceModel _$MultipleChoiceModelFromJson(Map<String, dynamic> json) =>
    MultipleChoiceModel(
      defaultStyle: json['d'] == null
          ? null
          : McDefaultStyleModel.fromJson(json['d'] as Map<String, dynamic>),
      selectionStyle: json['s'] == null
          ? null
          : McSelectionStyleModel.fromJson(json['s'] as Map<String, dynamic>),
      optionValues: (json['o'] as List<dynamic>?)
          ?.map((e) => McOptionValuesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      padding: json['padding'] == null
          ? null
          : PaddingModel.fromJson(json['padding'] as Map<String, dynamic>),
      analyticsFieldsName: json['aFn'] as String?,
    )..type = json['type'] as String;

Map<String, dynamic> _$MultipleChoiceModelToJson(
        MultipleChoiceModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'd': instance.defaultStyle,
      's': instance.selectionStyle,
      'o': instance.optionValues,
      'padding': instance.padding,
      'aFn': instance.analyticsFieldsName,
    };
