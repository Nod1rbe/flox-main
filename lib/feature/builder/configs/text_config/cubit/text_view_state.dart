part of 'text_view_cubit.dart';

final class TextViewState {
  final TextConfig config;

  TextViewState({required this.config});

  factory TextViewState.initial(TextConfig config) => TextViewState(config: config);
}
