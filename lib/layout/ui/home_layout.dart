import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/navigation/navigation.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (BuildContext context, AppState state) {
        if (state is NewPostState) {
          AppCubit.get(context).clearImageFile(isEditingProfile: false);
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: Text(
              cubit.titles[cubit.bottomNavBarIndex],
            ),
            actions: [
              defaultIconButton(
                splashRadius: 0.1,
                onPressed: () {
                  /*TODO*/
                },
                icon: IconBroken.Notification,
                iconColor: Colors.black,
                splashColor: Colors.transparent,
              ),
              defaultIconButton(
                splashRadius: 0.1,
                onPressed: () {
                  /*TODO*/
                },
                icon: IconBroken.Search,
                iconColor: Colors.black,
                splashColor: Colors.transparent,
              ),
              defaultIconButton(
                splashRadius: 0.1,
                onPressed: () {
                  cubit.logout(context);
                },
                icon: IconBroken.Logout,
                iconColor: Colors.black,
                splashColor: Colors.transparent,
              ),
            ],
          ),
          bottomNavigationBar: bottomNavBar(cubit),
          body: Column(
            children: [
              if (!FirebaseAuth.instance.currentUser!.emailVerified)
                verificationWarning(),
              Expanded(child: cubit.screens[cubit.bottomNavBarIndex])
            ],
          ),
        );
      },
    );
  }

  Widget bottomNavBar(AppCubit cubit) {
    return BottomNavigationBar(
      onTap: (int index) {
        cubit.changeBottomNavBarIndex(index);
      },
      selectedFontSize: 15.0,
      unselectedFontSize: 13.0,
      //iconSize: 26,
      elevation: 10.0,
      currentIndex: cubit.bottomNavBarIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            IconBroken.Home,
            size: cubit.bottomNavBarIndex == 0 ? 28.0 : 20.0,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            IconBroken.Chat,
            size: cubit.bottomNavBarIndex == 1 ? 28.0 : 20.0,
          ),
          label: 'Chats',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            IconBroken.Plus,
          ),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            IconBroken.Location,
            size: cubit.bottomNavBarIndex == 3 ? 28.0 : 20.0,
          ),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            IconBroken.Setting,
            size: cubit.bottomNavBarIndex == 4 ? 28.0 : 20.0,
          ),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget verificationWarning() {
    return Container(
      color: Colors.amber.withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: Text(
                'Please verify your email, check your inbox',
                style: labelStyle.copyWith(fontSize: 17.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

