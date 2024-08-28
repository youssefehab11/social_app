// ignore_for_file: non_constant_identifier_names

import 'dart:math';

late String USER_ID;

enum ImageTypes {
  profileImage,
  coverImage,
  postImage,
}

enum ImageFileTypes{
  profileImageFile,
  coverImageFile,
  postImageFile,
}

const double messageBorderRadius = 20.0;

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));