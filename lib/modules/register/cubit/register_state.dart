part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String error;

  RegisterErrorState(this.error);
}

class SaveToFirebaseErrorState extends RegisterState {
  final String error;

  SaveToFirebaseErrorState(this.error);
}

class ToggleVisibilityState extends RegisterState {}

class RegisterPasswordFocusState extends RegisterState {}

class RegisterPasswordUnFocusState extends RegisterState {}
