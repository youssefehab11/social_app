// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/ui/home_layout.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/register/ui/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/navigation/navigation.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            loginValidator(
              state: state,
              context: context,
            );
          },
          builder: (context, state) {
            LoginCubit cubit = LoginCubit.get(context);
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: titleStyle,
                      ),
                      const SizedBox(
                        height: 20.0,
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
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).nextFocus();
                          }),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Focus(
                        onFocusChange: (isFocusChange) {
                          cubit.loginPasswordFocusChange();
                        },
                        child: defaultTextFormField(
                          controller: passwordController,
                          focusNode: cubit.loginPasswordFocus,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.go,
                          context: context,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: cubit.isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onPressed: () {
                            cubit.toggleInputVisibility();
                          },
                          isInputVisible: cubit.isVisible,
                          onFieldSubmitted: (String value) {
                            cubit.login(
                              emailAddress: emailAddressController.text,
                              password: passwordController.text,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Builder(
                        builder: (context) {
                          if (state is LoginLoadingState) {
                            return circularLoading();
                          } else {
                            return defaultButton(
                              label: 'Login',
                              onPressed: () {
                                cubit.login(
                                  emailAddress: emailAddressController.text,
                                  password: passwordController.text,
                                );
                              },
                              labelFont: 20.0,
                              buttonWidth: double.infinity,
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Don\'t have account?',
                            style: defaultFont.copyWith(
                                fontSize: 16.0, fontWeight: FontWeight.w400,
                            ),
                          ),
                          defaultTextButton(
                            label: 'Create Account',
                            labelStyle: labelStyle.copyWith(color: Colors.blue, fontSize: 16.0),
                            onPressed: () {
                              navigateTo(context, RegisterScreen());
                            },
                          ),
                        ],
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

  void loginValidator({
    required BuildContext context,
    required LoginState state,
  }) {
    if (state is LoginSuccessState) {
      if (state.isVerified) {
        showToast(
          message: 'Login Successful',
          context: context,
          color: Colors.green,
          icon: IconBroken.Shield_Done,
          duration: 1300,
        );
        navigateAndRemove(context, const HomeLayout());
      } else {
        showToast(
            message: 'You must verify your Email check your inbox',
            context: context,
            textColor: Colors.black,
            color: Colors.amber,
            icon: IconBroken.Danger,
            iconColor: Colors.black);
        navigateAndRemove(context, const HomeLayout());
      }
    } else if (state is LoginErrorState) {
      showToast(
        message: state.error,
        context: context,
        color: Colors.red,
        icon: IconBroken.Shield_Fail,
      );
    }
  }
}
