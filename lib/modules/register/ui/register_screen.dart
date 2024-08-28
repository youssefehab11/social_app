// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/ui/login_screen.dart';
import 'package:social_app/modules/register/cubit/register_cubit.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/navigation/navigation.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            registerValidator(
              context: context,
              state: state,
            );
          },
          builder: (context, state) {
            RegisterCubit cubit = RegisterCubit.get(context);
            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register',
                        style: titleStyle,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        controller: userNameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter your name';
                          }
                          return null;
                        },
                        label: 'User Name',
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        context: context,
                        prefixIcon: Icons.person_outlined,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultTextFormField(
                        controller: emailAddressController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter your email';
                          }
                          return null;
                        },
                        label: 'Email Address',
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        context: context,
                        prefixIcon: Icons.email_outlined,
                        onFieldSubmitted: (value){
                          FocusScope.of(context).nextFocus();
                        }
                      ),
                       const SizedBox(
                        height: 15.0,
                      ),
                      Focus(
                        onFocusChange: (isFocusChange){
                          cubit.registerPasswordFocusChange();
                        },
                        child: defaultTextFormField(
                          controller: passwordController,
                          focusNode: cubit.registerPasswordFocus,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          context: context,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: cubit.isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onPressed: () {
                            cubit.toggleInputVisibility();
                          },
                          onFieldSubmitted: (value){
                            FocusScope.of(context).nextFocus();
                          },
                          isInputVisible: cubit.isVisible,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultTextFormField(
                        controller: phoneNumberController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter your phone number';
                          }
                          return null;
                        },
                        label: 'Phone Number',
                        textInputType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        context: context,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Builder(
                        builder: (context) {
                          if (state is RegisterLoadingState) {
                            return circularLoading();
                          } else {
                            return defaultButton(
                              label: 'Register',
                              onPressed: () {
                                submitRegister(cubit);
                              },
                              labelFont: 20.0,
                              buttonWidth: double.infinity,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void submitRegister(RegisterCubit cubit) {
    if (formKey.currentState!.validate()) {
      cubit.createUser(
        userName: userNameController.text,
        emailAddress: emailAddressController.text,
        password: passwordController.text,
        phoneNumber: phoneNumberController.text,
      );
    }
  }

  void registerValidator({
    required BuildContext context,
    required RegisterState state,
  }) {
    if (state is RegisterSuccessState) {
      showToast(
        message:
            'Account created successfully, we have sent a verification code please check your inbox',
        context: context,
        color: Colors.grey,
        icon: IconBroken.Info_Circle,
        duration: 5000,
      );
      navigateAndRemove(context, LoginScreen());
    } else if (state is RegisterErrorState) {
      showToast(
        message: state.error,
        context: context,
        color: Colors.red,
        icon: IconBroken.Shield_Fail,
      );
    } else if (state is SaveToFirebaseErrorState) {
      showToast(
        message: state.error,
        context: context,
        color: Colors.red,
        icon: IconBroken.Shield_Fail,
      );
    }
  }
}
