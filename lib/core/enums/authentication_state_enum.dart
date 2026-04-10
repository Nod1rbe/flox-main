enum AuthenticationStateEnum {
  initial,
  dashboard,
  auth;

  bool get isInitial => this == AuthenticationStateEnum.initial;
  bool get isAuth => this == AuthenticationStateEnum.auth;
  bool get isDashboard => this == AuthenticationStateEnum.dashboard;
}
