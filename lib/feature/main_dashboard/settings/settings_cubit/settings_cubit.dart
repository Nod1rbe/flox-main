import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/submission_status.dart';
import 'package:flox/feature/main_dashboard/settings/data/models/user_data_model.dart';
import 'package:flox/feature/main_dashboard/settings/data/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  SettingsCubit(this._settingsRepository) : super(const SettingsState());

  getUserData() async {
    emit(state.copyWith(
      getUserDataStatus: SubmissionStatus.loading,
      errorMessage: '',
    ));

    final response = await _settingsRepository.getUserData();
    response.fold(
      (l) => emit(state.copyWith(
        getUserDataStatus: SubmissionStatus.failure,
        errorMessage: l,
      )),
      (r) => emit(state.copyWith(
        getUserDataStatus: SubmissionStatus.success,
        userData: r,
      )),
    );
  }

  logout() async {
    emit(state.copyWith(
      logoutStatus: SubmissionStatus.loading,
      errorMessage: '',
    ));
    final response = await _settingsRepository.logout();
    response.fold(
      (l) => emit(state.copyWith(
        logoutStatus: SubmissionStatus.failure,
        errorMessage: l,
      )),
      (r) => emit(state.copyWith(
        logoutStatus: SubmissionStatus.success,
      )),
    );
  }
}
