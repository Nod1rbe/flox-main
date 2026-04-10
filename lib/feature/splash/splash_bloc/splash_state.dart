part of 'splash_bloc.dart';

class SplashState extends Equatable {
  final AuthenticationStateEnum authStatus;

  const SplashState({
    this.authStatus = AuthenticationStateEnum.initial,
  });

  SplashState copyWith({
    AuthenticationStateEnum? authStatus,
  }) {
    return SplashState(
      authStatus: authStatus ?? this.authStatus,
    );
  }

  @override
  List<Object> get props => [authStatus];
}
