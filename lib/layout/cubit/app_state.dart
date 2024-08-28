part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class GetUserSuccessState extends AppState {}

class GetUserErrorState extends AppState {
  final String error;

  GetUserErrorState(this.error);
}

class GetUserLoadingState extends AppState {}

class ChangeBottomNavBarIndexState extends AppState {}

class NewPostState extends AppState {}

class LogoutState extends AppState {}

class PickImageState extends AppState {}

class NoPickImageState extends AppState {}

class UpdateLoadingState extends AppState {}

class UpdateSuccessState extends AppState {}

class UpdateErrorState extends AppState {}

class ClearImageFileState extends AppState {}

class CreatePostLoadingState extends AppState {}

class CreatePostSuccessState extends AppState {}

class CreatePostErrorState extends AppState {}

class GetPostsSuccessState extends AppState {}

class GetPostsErrorState extends AppState {}

class GetPostsLoadingState extends AppState {}

class EmptyTextFieldState extends AppState {}

class NotEmptyTextFieldState extends AppState {}

class GetUsersSuccessState extends AppState {}

class GetUsersErrorState extends AppState {}

class GetUsersLoadingState extends AppState {}

class SendMessageSuccessState extends AppState {}

class  SendMessageErrorState extends AppState {}

class GetMessagesSuccessState extends AppState {}