// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      padding: json['padding'] == null
          ? null
          : PaddingModel.fromJson(json['padding'] as Map<String, dynamic>),
      button: json['button'] == null
          ? null
          : ButtonModel.fromJson(json['button'] as Map<String, dynamic>),
      textField: json['textField'] == null
          ? null
          : TextFieldModel.fromJson(json['textField'] as Map<String, dynamic>),
      successRedirectUrl: json['srUrl'] as String?,
      failureCallbackUrl: json['fcUrl'] as String?,
      successCallbackUrl: json['scUrl'] as String?,
      amount: (json['a'] as num?)?.toInt(),
    )..type = json['type'] as String;

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'padding': instance.padding,
      'button': instance.button,
      'textField': instance.textField,
      'srUrl': instance.successRedirectUrl,
      'fcUrl': instance.failureCallbackUrl,
      'scUrl': instance.successCallbackUrl,
      'a': instance.amount,
    };
