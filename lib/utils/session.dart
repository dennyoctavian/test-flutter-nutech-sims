import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('token');
  }
}
