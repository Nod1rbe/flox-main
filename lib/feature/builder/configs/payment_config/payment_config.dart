import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/payment_config/model/payment_model.dart';
import 'package:flox/feature/builder/configs/payment_config/payment_config_widget.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flutter/cupertino.dart';

class PaymentConfig extends BaseConfig {
  final TextFieldConfig textFieldConfig;
  final ButtonConfig buttonConfig;
  final String successRedirectUrl;
  final String successCallbackUrl;
  final String failureCallbackUrl;
  final int amount;

  PaymentConfig({
    required super.padding,
    required this.textFieldConfig,
    required this.buttonConfig,
    required this.successRedirectUrl,
    required this.successCallbackUrl,
    required this.failureCallbackUrl,
    required this.amount,
  }) : super(type: ViewType.payment);

  factory PaymentConfig.fromModel(PaymentModel model) {
    return PaymentConfig(
      padding: EdgeInsets.zero.fromPaddingModel(model.padding),
      textFieldConfig: TextFieldConfig.fromModel(model.textField ?? TextFieldModel.sample()),
      buttonConfig: ButtonConfig.fromModel(model.button ?? ButtonModel.sample()),
      successRedirectUrl: model.successRedirectUrl ?? '',
      successCallbackUrl: model.failureCallbackUrl ?? '',
      failureCallbackUrl: model.failureCallbackUrl ?? '',
      amount: model.amount ?? 0,
    );
  }

  @override
  BaseConfigModel toModel() {
    return PaymentModel(
      padding: PaddingModel.fromEdgeInsets(padding),
      textField: textFieldConfig.toModel(),
      button: buttonConfig.toModel(),
      successRedirectUrl: successRedirectUrl,
      successCallbackUrl: successCallbackUrl,
      failureCallbackUrl: failureCallbackUrl,
      amount: amount,
    );
  }

  PaymentConfig copyWith({
    EdgeInsets? padding,
    TextFieldConfig? textFieldConfig,
    ButtonConfig? buttonConfig,
    String? successRedirectUrl,
    String? successCallbackUrl,
    String? failureCallbackUrl,
    int? amount,
  }) {
    return PaymentConfig(
      padding: padding ?? this.padding,
      textFieldConfig: textFieldConfig ?? this.textFieldConfig,
      buttonConfig: buttonConfig ?? this.buttonConfig,
      successRedirectUrl: successRedirectUrl ?? this.successRedirectUrl,
      successCallbackUrl: successCallbackUrl ?? this.successCallbackUrl,
      failureCallbackUrl: failureCallbackUrl ?? this.failureCallbackUrl,
      amount: amount ?? this.amount,
    );
  }

  @override
  Widget toWidget(bool isSelected, {Key? key}) => PaymentConfigWidget(key: key, config: this, isSelected: isSelected);

  @override
  String toString() {
    return 'PaymentConfig{textFieldConfig: $textFieldConfig, buttonConfig: $buttonConfig, successRedirectUrl: $successRedirectUrl, successCallbackUrl: $successCallbackUrl, failureCallbackUrl: $failureCallbackUrl, amount: $amount}';
  }
}
