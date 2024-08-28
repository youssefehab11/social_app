import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/navigation/navigation.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

//cover
//https://img.freepik.com/free-photo/side-view-young-man-standing-beach-against-blue-sky_23-2148103026.jpg

//Profile
//https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?t=st=1710341706~exp=1710345306~hmac=6bad2e5adbbeea9b9bf655c9dddb29ca1e26b98c26efe59a4a5c86dc6f86715e&w=1060
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              SizedBox(
                height: 255.0,
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0))),
                      height: 200.0,
                      width: double.infinity,
                      child: Image.network(
                        cubit.userData.coverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            cubit.userData.profileImage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Flexible(
                child: Text(
                  cubit.userData.userName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: titleStyle,
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              Flexible(
                child: Text(
                  cubit.userData.bio,
                  textAlign: TextAlign.center,
                  style: caption.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 17.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '100',
                            style: defaultFont,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Post',
                            style: defaultFont,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '215',
                            style: defaultFont,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Photo',
                            style: defaultFont,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        onTap: () {
                          /*TODO*/
                        },
                        child: Column(
                          children: [
                            Text(
                              '2k',
                              style: defaultFont,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Followers',
                              style: defaultFont,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        onTap: () {
                          /*TODO*/
                        },
                        child: Column(
                          children: [
                            Text(
                              '76',
                              style: defaultFont,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Following',
                              style: defaultFont,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40.0,
                        child: OutlinedButton(
                          onPressed: () {
                            /*TODO*/
                          },
                          child: Text(
                            'Add Photo',
                            style: defaultFont.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    SizedBox(
                      height: 40.0,
                      child: OutlinedButton(
                        onPressed: () {
                          cubit.clearImageFile(isEditingProfile: true);
                          navigateTo(
                            context,
                            EditProfileScreen(userData: cubit.userData,),
                          );
                        },
                        child: const Icon(
                          IconBroken.Edit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
