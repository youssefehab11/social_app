import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static void saveString({
    required String key,
    required String value,
  }) async {
    await preferences.setString(key, value);
  }

  static String getString({
    required String key,
  }) {
    return preferences.getString(key)??'';
  }
  static Future<void> removeString(String key)async{
    await preferences.remove(key);
  }
}
