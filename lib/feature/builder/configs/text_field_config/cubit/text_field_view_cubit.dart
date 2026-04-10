import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'text_field_view_state.dart';

class TextFieldViewCubit extends Cubit<TextFieldViewState> {
  TextFieldViewCubit(TextFieldConfig config) : super(TextFieldViewState.initial(config));

  void updatePadding(EdgeInsets insets) => emit(TextFieldViewState(config: state.config.copyWith(padding: insets)));

  void updateCornerRadius(double radius) =>
      emit(TextFieldViewState(config: state.config.copyWith(cornerRadius: radius)));

  void updateHint(String hintText) => emit(TextFieldViewState(config: state.config.copyWith(hintText: hintText)));

  void updateAlignment(Alignment alignment) =>
      emit(TextFieldViewState(config: state.config.copyWith(alignment: alignment)));

  void updateTextColor(Color color) => emit(TextFieldViewState(config: state.config.copyWith(textColor: color)));

  void updateBackgroundColor(Color color) =>
      emit(TextFieldViewState(config: state.config.copyWith(backgroundColor: color)));

  void updateFontWeight(FontWeight weight) =>
      emit(TextFieldViewState(config: state.config.copyWith(fontWeight: weight)));

  void updateFontSize(double size) => emit(TextFieldViewState(config: state.config.copyWith(fontSize: size)));

  void updateFontFamily(String fontFamily) =>
      emit(TextFieldViewState(config: state.config.copyWith(fontFamily: fontFamily)));

  void updateAnalyticsFieldsName(String name) =>
      emit(TextFieldViewState(config: state.config.copyWith(analyticsFieldsName: name)));
}
