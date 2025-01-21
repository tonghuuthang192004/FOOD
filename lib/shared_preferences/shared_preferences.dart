
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
      'id_nguoi_dung': prefs.getString('id_nguoi_dung') ?? 'Chưa có ID',
      'ten': prefs.getString('ten') ?? 'huuthang',
      'so_dien_thoai': prefs.getString('so_dien_thoai') ?? '08232225016',
      'email': prefs.getString('email') ?? 'Chưa có email',
    };
  }


  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
