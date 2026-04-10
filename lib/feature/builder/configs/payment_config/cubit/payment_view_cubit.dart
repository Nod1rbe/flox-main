import 'package:flox/feature/builder/configs/payment_config/payment_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_view_state.dart';

class PaymentViewCubit extends Cubit<PaymentViewState> {
  PaymentViewCubit(PaymentConfig config) : super(PaymentViewState.initial(config));

  void updatePadding(EdgeInsets insets) => emit(PaymentViewState(config: state.config.copyWith(padding: insets)));

  void updateButtonText(String text) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(text: text);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonColor(Color buttonColor) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(buttonColor: buttonColor);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonTextColor(Color textColor) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(textColor: textColor);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonRadius(double radius) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(radius: radius);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonWidth(double width) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(width: width);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonHeight(double height) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(height: height);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonTextSize(double textSize) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(textSize: textSize);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonTextWeight(FontWeight textWeight) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(textWeight: textWeight);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonAlignment(Alignment alignment) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(alignment: alignment);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateButtonFontFamily(String fontFamily) {
    final updatedButtonConfig = state.config.buttonConfig.copyWith(fontFamily: fontFamily);
    final updatedConfig = state.config.copyWith(buttonConfig: updatedButtonConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldCornerRadius(double radius) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(cornerRadius: radius);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldHint(String hint) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(hintText: hint);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldPadding(EdgeInsets padding) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(padding: padding);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldAlignment(Alignment alignment) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(alignment: alignment);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldTextColor(Color color) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(textColor: color);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldBackgroundColor(Color color) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(backgroundColor: color);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldFontWeight(FontWeight weight) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(fontWeight: weight);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldFontSize(double size) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(fontSize: size);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldFontFamily(String fontFamily) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(fontFamily: fontFamily);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }

  void updateTextFieldAnalyticsFieldsName(String name) {
    final updatedTextFieldConfig = state.config.textFieldConfig.copyWith(analyticsFieldsName: name);
    final updatedConfig = state.config.copyWith(textFieldConfig: updatedTextFieldConfig);
    emit(PaymentViewState(config: updatedConfig));
  }
}
