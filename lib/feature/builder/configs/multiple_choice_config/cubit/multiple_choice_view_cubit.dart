import 'package:flox/feature/builder/configs/multiple_choice_config/mc_option_values_config.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/multiple_choice_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'multiple_choice_view_state.dart';

class MultipleChoiceViewCubit extends Cubit<MultipleChoiceViewState> {
  MultipleChoiceViewCubit(MultipleChoiceConfig config) : super(MultipleChoiceViewState.initial(config));

  void updateMultiSelection(bool multiSelection) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          defaultStyle: state.config.defaultStyle.copyWith(
            multiSelection: multiSelection,
          ),
        ),
      ),
    );
  }

  updatePadding(EdgeInsets padding) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(padding: padding),
      ),
    );
  }

  void updateShowIcons(bool showIcons) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          defaultStyle: state.config.defaultStyle.copyWith(
            showIcon: showIcons,
          ),
        ),
      ),
    );
  }

  void updateCornerRadius(double radius) {
    if (radius >= 0) {
      emit(
        MultipleChoiceViewState(
          config: state.config.copyWith(
            defaultStyle: state.config.defaultStyle.copyWith(
              cornerRadius: radius,
            ),
          ),
        ),
      );
    }
  }

  void updateAlignment(TextAlign alignment) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          defaultStyle: state.config.defaultStyle.copyWith(
            alignment: alignment,
          ),
        ),
      ),
    );
  }

  void updateTextColor(Color color) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          defaultStyle: state.config.defaultStyle.copyWith(
            textColor: color,
          ),
        ),
      ),
    );
  }

  void updateBackgroundColor(Color color) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          defaultStyle: state.config.defaultStyle.copyWith(
            backgroundColor: color,
          ),
        ),
      ),
    );
  }

  void updateFontWeight(FontWeight weight) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          defaultStyle: state.config.defaultStyle.copyWith(
            fontWeight: weight,
          ),
        ),
      ),
    );
  }

  void updateFontSize(double size) {
    if (size > 0) {
      emit(
        MultipleChoiceViewState(
          config: state.config.copyWith(
            defaultStyle: state.config.defaultStyle.copyWith(
              fontSize: size,
            ),
          ),
        ),
      );
    }
  }

  void updateFontFamily(String fontFamily) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          defaultStyle: state.config.defaultStyle.copyWith(
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  void updateSelectedTextColor(Color color) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          selectedStyle: state.config.selectedStyle.copyWith(
            textColor: color,
          ),
        ),
      ),
    );
  }

  void updateSelectedBackgroundColor(Color color) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          selectedStyle: state.config.selectedStyle.copyWith(
            backgroundColor: color,
          ),
        ),
      ),
    );
  }

  void updateAnalyticsFieldsName(String name) {
    emit(MultipleChoiceViewState(config: state.config.copyWith(analyticsFieldsName: name)));
  }

  void updateSelectedFontWeight(FontWeight weight) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          selectedStyle: state.config.selectedStyle.copyWith(
            fontWeight: weight,
          ),
        ),
      ),
    );
  }

  void updateSelectedFontSize(double size) {
    if (size > 0) {
      emit(
        MultipleChoiceViewState(
          config: state.config.copyWith(
            selectedStyle: state.config.selectedStyle.copyWith(
              fontSize: size,
            ),
          ),
        ),
      );
    }
  }

  void updateSelectedFontFamily(String fontFamily) {
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          selectedStyle: state.config.selectedStyle.copyWith(
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  void addOption(String text, String leadingIcon) {
    final newOption = McOptionValuesConfig(text: text, leadingIcon: leadingIcon);
    final updatedOptions = List<McOptionValuesConfig>.from(state.config.optionValues)..add(newOption);
    emit(
      MultipleChoiceViewState(
        config: state.config.copyWith(
          optionValues: updatedOptions,
        ),
      ),
    );
  }

  void updateOption(int index, {String? text, String? leadingIcon}) {
    if (index < 0 || index >= state.config.optionValues.length) return;
    final updatedOption = McOptionValuesConfig(
      text: text ?? state.config.optionValues[index].text,
      leadingIcon: leadingIcon ?? state.config.optionValues[index].leadingIcon,
    );
    final updatedOptions = List<McOptionValuesConfig>.from(state.config.optionValues)..[index] = updatedOption;
    emit(
      MultipleChoiceViewState(config: state.config.copyWith(optionValues: updatedOptions)),
    );
  }

  void removeOption(int index) {
    if (index < 0 || index >= state.config.optionValues.length) return;
    final updatedOptions = List<McOptionValuesConfig>.from(state.config.optionValues)..removeAt(index);
    emit(
      MultipleChoiceViewState(config: state.config.copyWith(optionValues: updatedOptions)),
    );
  }
}
