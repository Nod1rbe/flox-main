part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final bool isLoginForm;
  final SubmissionStatus loginStatus;
  final String loginErrorMessage;
  final SubmissionStatus registerStatus;
  final String registerErrorMessage;
  final SubmissionStatus googleSignInStatus;
  final String googleSignInErrorMessage;

  const AuthenticationState({
    this.isLoginForm = true,
    this.loginStatus = SubmissionStatus.initial,
    this.registerStatus = SubmissionStatus.initial,
    this.googleSignInStatus = SubmissionStatus.initial,
    this.googleSignInErrorMessage = '',
    this.loginErrorMessage = '',
    this.registerErrorMessage = '',
  });

  AuthenticationState copyWith({
    bool? isLoginForm,
    SubmissionStatus? loginStatus,
    String? loginErrorMessage,
    SubmissionStatus? registerStatus,
    String? registerErrorMessage,
    SubmissionStatus? googleSignInStatus,
    String? googleSignInErrorMessage,
  }) {
    return AuthenticationState(
      isLoginForm: isLoginForm ?? this.isLoginForm,
      loginStatus: loginStatus ?? this.loginStatus,
      loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
      registerStatus: registerStatus ?? this.registerStatus,
      registerErrorMessage: registerErrorMessage ?? this.registerErrorMessage,
      googleSignInStatus: googleSignInStatus ?? this.googleSignInStatus,
      googleSignInErrorMessage: googleSignInErrorMessage ?? this.googleSignInErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoginForm,
        loginStatus,
        loginErrorMessage,
        registerStatus,
        registerErrorMessage,
        googleSignInStatus,
        googleSignInErrorMessage,
      ];
}
