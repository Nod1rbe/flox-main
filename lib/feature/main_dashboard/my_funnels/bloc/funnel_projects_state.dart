part of 'funnel_projects_bloc.dart';

@immutable
class FunnelProjectsState extends Equatable {
  final SubmissionStatus getStatus;
  final SubmissionStatus createStatus;
  final SubmissionStatus deleteStatus;
  final SubmissionStatus updateStatus;

  final String getErrorMessage;
  final String createErrorMessage;
  final String deleteErrorMessage;
  final String updateErrorMessage;

  final List<FunnelProjectsModel> funnels;
  final FunnelProjectsModel insertedFunnel;

  const FunnelProjectsState({
    this.getStatus = SubmissionStatus.initial,
    this.createStatus = SubmissionStatus.initial,
    this.deleteStatus = SubmissionStatus.initial,
    this.updateStatus = SubmissionStatus.initial,
    this.getErrorMessage = '',
    this.createErrorMessage = '',
    this.deleteErrorMessage = '',
    this.updateErrorMessage = '',
    this.funnels = const [],
    this.insertedFunnel = const FunnelProjectsModel(),
  });

  FunnelProjectsState copyWith({
    SubmissionStatus? getStatus,
    SubmissionStatus? createStatus,
    SubmissionStatus? deleteStatus,
    SubmissionStatus? updateStatus,
    String? getErrorMessage,
    String? createErrorMessage,
    String? deleteErrorMessage,
    String? updateErrorMessage,
    List<FunnelProjectsModel>? funnels,
    FunnelProjectsModel? insertedFunnel,
  }) {
    return FunnelProjectsState(
      getStatus: getStatus ?? this.getStatus,
      createStatus: createStatus ?? this.createStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      getErrorMessage: getErrorMessage ?? this.getErrorMessage,
      createErrorMessage: createErrorMessage ?? this.createErrorMessage,
      deleteErrorMessage: deleteErrorMessage ?? this.deleteErrorMessage,
      updateErrorMessage: updateErrorMessage ?? this.updateErrorMessage,
      funnels: funnels ?? this.funnels,
      insertedFunnel: insertedFunnel ?? this.insertedFunnel,
    );
  }

  @override
  List<Object?> get props => [
        getStatus,
        createStatus,
        deleteStatus,
        updateStatus,
        getErrorMessage,
        createErrorMessage,
        deleteErrorMessage,
        updateErrorMessage,
        funnels,
        insertedFunnel,
      ];
}
