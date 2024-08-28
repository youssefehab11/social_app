import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_data.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  bool isVisible = false;

  FocusNode registerPasswordFocus = FocusNode();

  void registerPasswordFocusChange(){
    if(registerPasswordFocus.hasFocus){
      emit(RegisterPasswordFocusState());
    }
    else{
      emit(RegisterPasswordUnFocusState());
    }
  }

  void toggleInputVisibility() {
    isVisible = !isVisible;
    emit(ToggleVisibilityState());
  }

  void createUser({
    required String userName,
    required String emailAddress,
    required String password,
    required String phoneNumber,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailAddress, password: password)
        .then((value) {
      saveUserToFirebase(
        userName: userName,
        emailAddress: emailAddress,
        password: password,
        phoneNumber: phoneNumber,
        id: value.user!.uid,
      );
    }).catchError((error) {
      if(error is FirebaseAuthException){
        emit(RegisterErrorState(error.code));
      }
      else{
        emit(RegisterErrorState(error.toString()));
      }
    });
  }

  void saveUserToFirebase({
    required String userName,
    required String emailAddress,
    required String password,
    required String phoneNumber,
    required String id,
  }) {
    UserData model = UserData(
      userName: userName,
      id: id,
      emailAddress: emailAddress,
      phoneNumber: phoneNumber,
      bio: 'Write your bio...',
      profileImage: 'https://i.pinimg.com/564x/dd/c2/ba/ddc2baeed75b0aa527c107fab156c584.jpg',
      coverImage: 'https://img.freepik.com/free-photo/toy-bricks-table-with-word-welcome_144627-47504.jpg?t=st=1710340643~exp=1710344243~hmac=42af258ac06160ab3dd293d1a1d5faf0caa57db21aabcae366f8b576f8e51094&w=1060',
    );
    FirebaseFirestore.instance.collection('Users').doc(id).set(model.toMap()).then((value) {
      sendEmailVerification();
    }).catchError((error){
      if(error is FirebaseException){
        emit(SaveToFirebaseErrorState(error.code));
      }
      else{
        emit(SaveToFirebaseErrorState(error.toString()));
      }
    });
  }

  void sendEmailVerification(){
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    emit(RegisterSuccessState());
  }

}

