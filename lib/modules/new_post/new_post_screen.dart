import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  final TextEditingController postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if(state is CreatePostSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: const Text(
                'Create Post',
              ),
              hasArrowBack: true,
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: defaultTextButton(
                    label: 'Post',
                    onPressed: postTextController.text.isNotEmpty || cubit.postImageFile != null?() {
                      cubit.createPost(postText: postTextController.text);
                    }: null,

                    labelStyle: defaultFont.copyWith(
                      color: postTextController.text != '' || cubit.postImageFile != null? Theme.of(context).primaryColor: Colors.grey,
                    ),
                  ),
                ),
              ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is CreatePostLoadingState)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35.0,
                      backgroundImage: NetworkImage(
                        cubit.userData.profileImage,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              cubit.userData.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: labelStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: postTextController,
                    keyboardType: TextInputType.multiline,
                    scrollPhysics: const BouncingScrollPhysics(),
                    onChanged: (String text){
                      cubit.textFieldChanged(text);
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLines: null,
                    style: const TextStyle(fontSize: 20.0),
                    decoration: const InputDecoration(
                      hintText: 'What is in your mind...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if(cubit.postImageFile != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 200.0,
                        width: double.infinity,
                        child: Image.file(
                          File(cubit.postImageFile!.path),
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: defaultIconButton(
                            onPressed: () {
                              cubit.clearImageFile(isEditingProfile: false);
                            },
                            splashRadius: 0.1,
                            icon: IconBroken.Close_Square,
                            iconColor: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: defaultTextButton(
                        label: 'Add Photo',
                        onPressed: () {
                          cubit.pickImage(imageTypes: ImageTypes.postImage);
                        },
                        labelStyle: labelStyle.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                        icon: IconBroken.Image,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: defaultTextButton(
                        label: 'Add Tag',
                        onPressed: () {
                          /*TODO*/
                        },
                        labelStyle: labelStyle.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                        icon: Icons.tag,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
