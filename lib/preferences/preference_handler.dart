import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String isId = "isId";

  //Save data login pada saat login
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  //Ambil data login pada saat mau login / ke dashboard
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  //Hapus data login pada saat logout
  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  //Save data ID pada saat login
  static saveID(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(isLogin, value);
  }

  //Ambil data ID pada saat mau login / ke dashboard
  static getID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(isLogin);
  }

  //Hapus data ID pada saat logout
  static removeID() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

}