import 'package:flutter/material.dart';
import 'package:furtopia/navigation/bottom_nav.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/login_page.dart';

class SplashScreenFurtopia extends StatefulWidget {
  const SplashScreenFurtopia({super.key});

  @override
  State<SplashScreenFurtopia> createState() => _SplashScreenFurtopiaState();
}

class _SplashScreenFurtopiaState extends State<SplashScreenFurtopia> {
  @override
  void initState() {
    super.initState();
    isLoginFunction();
  }

  isLoginFunction() async {
    Future.delayed(Duration(seconds: 3)).then((value) async {
      var isLogin = await PreferenceHandler.getLogin();
      print(isLogin);
      if (isLogin != null && isLogin == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground() ,buildLayer()]));
  }

  SafeArea buildLayer(){
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Image.asset(AppImages.logo)
      ],));}

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.bgg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}