part of 'multiple_choice_view_cubit.dart';

final class MultipleChoiceViewState {
  final MultipleChoiceConfig config;

  MultipleChoiceViewState({
    required this.config,
  });

  factory MultipleChoiceViewState.initial(MultipleChoiceConfig config) =>
      MultipleChoiceViewState(config: config);
}
