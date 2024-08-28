import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class EditProfileScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  EditProfileScreen({
    super.key,
    required UserData userData,
  }) {
    userNameController.text = userData.userName;
    bioController.text = userData.bio;
    phoneController.text = userData.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is UpdateSuccessState) {
          showToast(
            message: 'Updated Successfully',
            context: context,
            color: Colors.green,
            icon: IconBroken.Tick_Square,
            iconColor: Colors.white,
          );
          Navigator.pop(context);
          AppCubit.get(context).getUserData();
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: appBar(context, cubit),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if(state is UpdateLoadingState)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(),
                    ),
                  images(cubit, context),
                  const SizedBox(
                    height: 20.0,
                  ),
                  profileData(
                    context: context,
                    cubit: cubit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget appBar(BuildContext context, AppCubit cubit) {
    return defaultAppBar(
      context: context,
      hasArrowBack: true,
      title: const Text(
        'Edit Profile',
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: defaultTextButton(
            label: 'Update',
            onPressed: () {
              cubit.updateProfile(
                userName: userNameController.text,
                phoneNumber: phoneController.text,
                bio: bioController.text,
              );
            },
            labelStyle: defaultFont.copyWith(
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget images(AppCubit cubit, BuildContext context) {
    return SizedBox(
      height: 255.0,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          coverImage(cubit),
          profileImage(cubit, context),
        ],
      ),
    );
  }

  Widget coverImage(AppCubit cubit) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            height: 200.0,
            width: double.infinity,
            child: cubit.coverImageFile == null
                ? Image.network(
              cubit.userData.coverImage,
              fit: BoxFit.cover,
            )
                : Image.file(
              File(cubit.coverImageFile!.path),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: defaultIconButton(
                onPressed: () {
                  cubit.pickImage(imageTypes: ImageTypes.coverImage);
                },
                splashRadius: 0.1,
                icon: IconBroken.Camera,
                iconColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget profileImage(AppCubit cubit, BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          height: 150.0,
          width: 150.0,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .scaffoldBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            backgroundImage: cubit.profileImageFile == null
                ? NetworkImage(
              cubit.userData.profileImage,
            )
                : Image
                .file(
              File(
                cubit.profileImageFile!.path,
              ),
            )
                .image,
          ),
        ),
        CircleAvatar(
          child: defaultIconButton(
            onPressed: () {
              cubit.pickImage(imageTypes: ImageTypes.profileImage);
            },
            splashRadius: 0.1,
            icon: IconBroken.Camera,
            iconColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget profileData({
    required BuildContext context,
    required AppCubit cubit,
  }) {
    return Column(
      children: [
        defaultTextFormField(
          controller: userNameController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'Name must not be empty';
            }
            return null;
          },
          label: 'User Name',
          textInputType: TextInputType.name,
          textInputAction: TextInputAction.next,
          context: context,
          prefixIcon: IconBroken.Profile,
        ),
        const SizedBox(
          height: 15.0,
        ),
        defaultTextFormField(
          controller: bioController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'Bio must not be empty';
            }
            return null;
          },
          label: 'Bio',
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.next,
          context: context,
          prefixIcon: IconBroken.Info_Circle,
        ),
        const SizedBox(
          height: 15.0,
        ),
        defaultTextFormField(
          controller: phoneController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'Phone must not be empty';
            }
            return null;
          },
          label: 'Phone Number',
          textInputType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          context: context,
          prefixIcon: IconBroken.Call,
        ),
      ],
    );
  }
}
