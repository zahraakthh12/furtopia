import 'package:flutter/material.dart';
import 'package:furtopia/firebase_options.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FurTopia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.shape6.withOpacity(0.92)),
      ),
      home: SplashScreenFurtopia(),
    );
  }
}