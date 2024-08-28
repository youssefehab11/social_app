import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/ui/home_layout.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'bloc_observer.dart';
import 'firebase_options.dart';
import 'modules/login/ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  USER_ID = CacheHelper.getString(key: 'userId');
  Bloc.observer = MyBlocObserver();
  late Widget startWidget;
  if (USER_ID != '') {
    startWidget = const HomeLayout();
  } else {
    startWidget = LoginScreen();
  }
  runApp(
    MyApp(
      startWidget: startWidget,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getPosts()..getUserData(),
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: startWidget,
      ),
    );
  }
}
