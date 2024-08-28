import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/shared/styles/styles.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'SF Pro Display',
  primarySwatch: primaryColor,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    titleTextStyle: titleStyle.copyWith(
      color: Colors.black,
    ),
    titleSpacing: 0.0,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    elevation: 0.0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: primaryColor,
  ),
);
