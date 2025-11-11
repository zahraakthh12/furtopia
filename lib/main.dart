import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final customFont = 'Poppins';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( fontFamily: customFont,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.shape6.withOpacity(0.92)),
      ),
      home: SplashScreenFurtopia(),
    );
  }
}