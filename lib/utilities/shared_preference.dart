import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static late final SharedPreferences _instance;

  static SharedPreferences get instance => _instance;

  static Future<SharedPreferences> init() async =>
      _instance = await SharedPreferences.getInstance();
}