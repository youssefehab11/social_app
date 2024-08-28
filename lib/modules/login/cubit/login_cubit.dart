import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  bool isVisible = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode loginPasswordFocus = FocusNode();

  void loginPasswordFocusChange(){
    if(loginPasswordFocus.hasFocus){
      emit(LoginPasswordFocusState());
    }
    else{
      emit(LoginPasswordUnFocusState());
    }
  }


  void toggleInputVisibility() {
    isVisible = !isVisible;
    emit(ToggleVisibilityState());
  }


  void login({
    required String emailAddress,
    required String password,
  }) async{
    if(formKey.currentState!.validate()){
      //This microtask to emit the LoginPasswordUnFocusState first then the loading state
      await Future.microtask(() {
        emit(LoginLoadingState());
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      ).then((value) {
        CacheHelper.saveString(key: 'userId', value: value.user!.uid);
        USER_ID = value.user!.uid;
        print(USER_ID);
        emit(LoginSuccessState(value.user!.emailVerified));
      }).catchError((error) {
        if (error is FirebaseAuthException) {
          emit(LoginErrorState(error.code));
        } else {
          emit(LoginErrorState(error.toString()));
        }
      });
    }
  }
}
