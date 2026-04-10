import 'package:flox/feature/builder/configs/progress_config/model/progress_values_model.dart';

class ProgressConfigValues {
  final String text;
  final double duration;

  ProgressConfigValues({required this.text, required this.duration});

  factory ProgressConfigValues.fromModel(ProgressValuesModel model) {
    return ProgressConfigValues(text: model.text ?? '', duration: model.duration ?? 1);
  }

  ProgressValuesModel toModel() {
    return ProgressValuesModel(text: text, duration: duration);
  }

  ProgressConfigValues copyWith({
    String? text,
    double? duration,
  }) {
    return ProgressConfigValues(
      text: text ?? this.text,
      duration: duration ?? this.duration,
    );
  }
}
