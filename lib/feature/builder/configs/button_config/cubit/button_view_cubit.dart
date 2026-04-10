import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'button_view_state.dart';

class ButtonViewCubit extends Cubit<ButtonViewState> {
  ButtonViewCubit(ButtonConfig config) : super(ButtonViewState.initial(config));

  void updatePadding(EdgeInsets insets) => emit(ButtonViewState(config: state.config.copyWith(padding: insets)));

  void updateText(String text) => emit(ButtonViewState(config: state.config.copyWith(text: text)));

  void updateButtonColor(Color buttonColor) =>
      emit(ButtonViewState(config: state.config.copyWith(buttonColor: buttonColor)));

  void updateTextColor(Color textColor) => emit(ButtonViewState(config: state.config.copyWith(textColor: textColor)));

  void updateRadius(double radius) => emit(ButtonViewState(config: state.config.copyWith(radius: radius)));

  void updateWidth(double width) => emit(ButtonViewState(config: state.config.copyWith(width: width)));

  void updateHeight(double height) => emit(ButtonViewState(config: state.config.copyWith(height: height)));

  void updateTextSize(double textSize) => emit(ButtonViewState(config: state.config.copyWith(textSize: textSize)));

  void updateTextWeight(FontWeight textWeight) =>
      emit(ButtonViewState(config: state.config.copyWith(textWeight: textWeight)));

  void updateAlignment(Alignment alignment) =>
      emit(ButtonViewState(config: state.config.copyWith(alignment: alignment)));

  void updateFontFamily(String fontFamily) =>
      emit(ButtonViewState(config: state.config.copyWith(fontFamily: fontFamily)));
}
