import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String keyIsLogin = "isLogin";
  static const String keyUserId = "userId";

  // Simpan status login
  static Future<void> saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLogin, value);
  }

  // Ambil status login
  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLogin);
  }

  // Hapus status login
  static Future<void> removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsLogin);
  }

  // Simpan ID user
  static Future<void> saveID(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserId, value);
  }

  // Ambil ID user
  static Future<int?> getID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId);
  }

  // Hapus ID user
  static Future<void> removeID() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserId);
  }
}
