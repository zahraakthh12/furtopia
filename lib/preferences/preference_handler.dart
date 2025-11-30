import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String isToken = "isToken";
  static const String keyUserId = "userId";

  //Save data login pada saat login

  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(isToken, value);
  }

  //Ambil data login pada saat mau login / ke dashboard
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  static getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isToken);
  }

  //Hapus data login pada saat logout
  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  static removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isToken);
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