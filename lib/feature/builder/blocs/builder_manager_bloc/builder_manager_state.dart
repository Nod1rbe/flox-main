part of 'builder_manager_cubit.dart';

final class BuilderManagerState extends Equatable {
  final SubmissionStatus saveStatus;
  final SubmissionStatus getProjectStatus;
  final SubmissionStatus showLinksStatus;
  final String errorMessage;
  final List<String> launcherLinks;
  final List<PageData> pages;

  const BuilderManagerState({
    this.saveStatus = SubmissionStatus.initial,
    this.getProjectStatus = SubmissionStatus.initial,
    this.showLinksStatus = SubmissionStatus.initial,
    this.errorMessage = '',
    this.launcherLinks = const [],
    this.pages = const [],
  });

  BuilderManagerState copyWith({
    SubmissionStatus? saveStatus,
    SubmissionStatus? getProjectStatus,
    SubmissionStatus? showLinksStatus,
    String? errorMessage,
    List<String>? launcherLinks,
    List<PageData>? pages,
  }) {
    return BuilderManagerState(
      saveStatus: saveStatus ?? this.saveStatus,
      getProjectStatus: getProjectStatus ?? this.getProjectStatus,
      launcherLinks: launcherLinks ?? this.launcherLinks,
      showLinksStatus: showLinksStatus ?? this.showLinksStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [
        saveStatus,
        getProjectStatus,
        showLinksStatus,
        errorMessage,
        launcherLinks,
        pages,
      ];
}
