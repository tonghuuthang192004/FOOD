
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUserData(Map<String, String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  static Future<Map<String, String>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id_nguoi_dung': prefs.getString('id_nguoi_dung') ?? '',
      'ten': prefs.getString('ten') ?? '',
      'email': prefs.getString('email') ?? '',
    };
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
