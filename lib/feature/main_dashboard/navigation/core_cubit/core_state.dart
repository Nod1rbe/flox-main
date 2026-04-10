part of 'core_cubit.dart';

class CoreState extends Equatable {
  final SubmissionStatus getStatus;

  const CoreState({this.getStatus = SubmissionStatus.initial});

  CoreState copyWith({SubmissionStatus? getStatus}) {
    return CoreState(getStatus: getStatus ?? this.getStatus);
  }

  @override
  List<Object?> get props => [getStatus];
}
