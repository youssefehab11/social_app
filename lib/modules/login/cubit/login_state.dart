part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final bool isVerified;
  LoginSuccessState(this.isVerified);
}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}

class ToggleVisibilityState extends LoginState {}

class LoginPasswordFocusState extends LoginState {}

class LoginPasswordUnFocusState extends LoginState {}
