import 'package:flox/feature/builder/configs/text_config/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'text_view_state.dart';

class TextViewCubit extends Cubit<TextViewState> {
  TextViewCubit(TextConfig config) : super(TextViewState.initial(config));

  void updatePadding(EdgeInsets insets) => emit(TextViewState(config: state.config.copyWith(padding: insets)));

  void updateText(String text) => emit(TextViewState(config: state.config.copyWith(text: text)));

  void updateColor(Color color) => emit(TextViewState(config: state.config.copyWith(color: color)));

  void updateSize(double size) => emit(TextViewState(config: state.config.copyWith(size: size)));

  void updateWeight(FontWeight weight) => emit(TextViewState(config: state.config.copyWith(weight: weight)));

  void updateFontFamily(String fontFamily) =>
      emit(TextViewState(config: state.config.copyWith(fontFamily: fontFamily)));

  void updateAlignment(TextAlign alignment) => emit(TextViewState(config: state.config.copyWith(alignment: alignment)));

  void updateLeadingIcon(String icon) => emit(TextViewState(config: state.config.copyWith(leadingIcon: icon)));
}
