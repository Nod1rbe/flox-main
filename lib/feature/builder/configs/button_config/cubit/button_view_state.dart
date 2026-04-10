part of 'button_view_cubit.dart';

final class ButtonViewState {
  final ButtonConfig config;

  ButtonViewState({required this.config});

  factory ButtonViewState.initial(ButtonConfig config) => ButtonViewState(config: config);
}
