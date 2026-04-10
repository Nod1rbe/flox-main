import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel implements BaseConfigModel {
  @override
  String type;

  @JsonKey(name: 'padding')
  final PaddingModel? padding;

  @JsonKey(name: 'button')
  final ButtonModel? button;

  @JsonKey(name: 'textField')
  final TextFieldModel? textField;

  @JsonKey(name: 'srUrl')
  final String? successRedirectUrl;

  @JsonKey(name: 'fcUrl')
  final String? failureCallbackUrl;

  @JsonKey(name: 'scUrl')
  final String? successCallbackUrl;

  @JsonKey(name: 'a')
  final int? amount;

  PaymentModel({
    this.padding,
    this.button,
    this.textField,
    this.successRedirectUrl,
    this.failureCallbackUrl,
    this.successCallbackUrl,
    this.amount
  }): type = ViewType.payment.name;

  @override
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

  factory PaymentModel.sample() => PaymentModel(
    padding: PaddingModel.sample,
    button: ButtonModel.sample(),
    textField: TextFieldModel.sample(),
    successRedirectUrl: 'https://www.google.com',
    failureCallbackUrl: 'https://www.google.com',
    successCallbackUrl: 'https://www.google.com',
    amount: 10000,
  );
}