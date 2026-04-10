part of 'splash_bloc.dart';

@immutable
sealed class SplashEvent {
  const SplashEvent();
}

class CheckAuthStatusEvent extends SplashEvent {}
