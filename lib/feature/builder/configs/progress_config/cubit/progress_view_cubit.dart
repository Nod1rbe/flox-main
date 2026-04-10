import 'package:flox/feature/builder/configs/progress_config/progress_config.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'progress_view_state.dart';

class ProgressViewCubit extends Cubit<ProgressViewState> {
  ProgressViewCubit(ProgressConfig config) : super(ProgressViewState.initial(config));

  void updatePadding(EdgeInsets insets) => emit(ProgressViewState(config: state.config.copyWith(padding: insets)));

  void updateHeight(double height) => emit(ProgressViewState(config: state.config.copyWith(height: height)));

  void updateCornerRadius(double radius) =>
      emit(ProgressViewState(config: state.config.copyWith(cornerRadius: radius)));

  void updateShowIcon(bool show) => emit(ProgressViewState(config: state.config.copyWith(showIcon: show)));

  void updateTextColor(Color color) => emit(ProgressViewState(config: state.config.copyWith(textColor: color)));

  void updateBackgroundColor(Color color) =>
      emit(ProgressViewState(config: state.config.copyWith(backgroundColor: color)));

  void updateFontWeight(FontWeight weight) =>
      emit(ProgressViewState(config: state.config.copyWith(fontWeight: weight)));

  void updateFontSize(double size) => emit(ProgressViewState(config: state.config.copyWith(fontSize: size)));

  void updateFontFamily(String fontFamily) =>
      emit(ProgressViewState(config: state.config.copyWith(fontFamily: fontFamily)));

  void updateProgressValues(List<ProgressConfigValues> values) =>
      emit(ProgressViewState(config: state.config.copyWith(progressValues: values)));

  void addProgressValue(String text, double duration) {
    final newValue = ProgressConfigValues(text: text, duration: duration);
    final updatedValues = List<ProgressConfigValues>.from(state.config.progressValues)..add(newValue);
    emit(
      ProgressViewState(
        config: state.config.copyWith(
          progressValues: updatedValues,
        ),
      ),
    );
  }

  void updateProgressValue(int index, {String? text, double? duration}) {
    if (index < 0 || index >= state.config.progressValues.length) return;
    final updatedValue = ProgressConfigValues(
      text: text ?? state.config.progressValues[index].text,
      duration: duration ?? state.config.progressValues[index].duration,
    );
    final updatedValues = List<ProgressConfigValues>.from(state.config.progressValues)..[index] = updatedValue;
    emit(
      ProgressViewState(
        config: state.config.copyWith(
          progressValues: updatedValues,
        ),
      ),
    );
  }

  void removeProgressValue(int index) {
    if (index < 0 || index >= state.config.progressValues.length) return;
    final updatedValues = List<ProgressConfigValues>.from(state.config.progressValues)..removeAt(index);
    emit(
      ProgressViewState(
        config: state.config.copyWith(
          progressValues: updatedValues,
        ),
      ),
    );
  }
}
