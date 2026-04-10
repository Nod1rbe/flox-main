part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final SubmissionStatus getUserDataStatus;
  final SubmissionStatus logoutStatus;
  final String errorMessage;
  final UserDataModel userData;

  const SettingsState({
    this.getUserDataStatus = SubmissionStatus.initial,
    this.logoutStatus = SubmissionStatus.initial,
    this.errorMessage = '',
    this.userData = const UserDataModel(),
  });

  SettingsState copyWith({
    SubmissionStatus? getUserDataStatus,
    SubmissionStatus? logoutStatus,
    String? errorMessage,
    UserDataModel? userData,
  }) {
    return SettingsState(
      getUserDataStatus: getUserDataStatus ?? this.getUserDataStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object?> get props => [
        getUserDataStatus,
        logoutStatus,
        errorMessage,
        userData,
      ];
}
