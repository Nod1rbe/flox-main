import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flox/core/enums/submission_status.dart';
import 'package:flox/feature/authentication/data/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;
  AuthenticationBloc(this._authRepository) : super(AuthenticationState()) {
    on<ChangeFormEvent>((event, emit) {
      emit(state.copyWith(isLoginForm: event.isLoginForm));
    });
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
  }

  void _onLogin(LoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(loginStatus: SubmissionStatus.loading));

    final result = await _authRepository.login(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (l) => emit(state.copyWith(
        loginStatus: SubmissionStatus.failure,
        loginErrorMessage: l,
      )),
      (r) => r
          ? emit(state.copyWith(loginStatus: SubmissionStatus.success))
          : emit(state.copyWith(
              loginStatus: SubmissionStatus.failure,
              loginErrorMessage: 'Login failed',
            )),
    );
  }

  void _onRegister(RegisterEvent event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(registerStatus: SubmissionStatus.loading));

    final result = await _authRepository.register(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (l) => emit(state.copyWith(
        registerStatus: SubmissionStatus.failure,
        registerErrorMessage: l,
      )),
      (r) => r
          ? emit(state.copyWith(registerStatus: SubmissionStatus.success))
          : emit(state.copyWith(
              registerStatus: SubmissionStatus.failure,
              registerErrorMessage: 'Registration failed',
            )),
    );
  }

  void _onSignInWithGoogle(SignInWithGoogleEvent event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(googleSignInStatus: SubmissionStatus.loading));

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (l) => emit(state.copyWith(
        googleSignInStatus: SubmissionStatus.failure,
        googleSignInErrorMessage: l,
      )),
      (r) => emit(state.copyWith(
        googleSignInStatus: SubmissionStatus.success,
      )),
    );
  }
}
