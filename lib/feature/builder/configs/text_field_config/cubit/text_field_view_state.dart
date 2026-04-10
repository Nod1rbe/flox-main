part of 'text_field_view_cubit.dart';

final class TextFieldViewState {
  final TextFieldConfig config;

  TextFieldViewState({required this.config});

  factory TextFieldViewState.initial(TextFieldConfig config) =>
      TextFieldViewState(config: config);
}
