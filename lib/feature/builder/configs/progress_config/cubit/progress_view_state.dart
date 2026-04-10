part of 'progress_view_cubit.dart';

final class ProgressViewState {
  final ProgressConfig config;

  ProgressViewState({required this.config});

  factory ProgressViewState.initial(ProgressConfig config) => ProgressViewState(config: config);
}
