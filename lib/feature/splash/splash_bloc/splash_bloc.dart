import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/authentication_state_enum.dart';
import 'package:flox/feature/authentication/data/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;
  SplashBloc(this._authRepository) : super(SplashState()) {
    on<CheckAuthStatusEvent>((event, emit) async {
      final client = _authRepository.currentUser;
      await Future.delayed(const Duration(seconds: 1));
      if (client == null) {
        emit(state.copyWith(authStatus: AuthenticationStateEnum.auth));
      } else {
        emit(state.copyWith(authStatus: AuthenticationStateEnum.dashboard));
      }
    });
  }
}
