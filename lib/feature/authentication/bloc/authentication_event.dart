part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

class ChangeFormEvent extends AuthenticationEvent {
  final bool isLoginForm;
  const ChangeFormEvent(this.isLoginForm);
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthenticationEvent {
  final String email;
  final String password;
  const RegisterEvent({required this.email, required this.password});
}

class SignInWithGoogleEvent extends AuthenticationEvent {}
