//Bahas Shared Preference
import 'package:flutter/material.dart';
import 'package:furtopia/constant/app_colors.dart';
import 'package:furtopia/constant/app_images.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/navigation/bottom_nav.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:furtopia/view/regist_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const id = "/login_screen18";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground() ,buildLayer()]));
  }

   login() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomNav()),
    );
  }

  final _formKey = GlobalKey<FormState>();
  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 80, bottom: 80, left: 25, right: 25),
          child: Container(padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(30), 
                  boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25), 
                                        offset: Offset(2, 2), 
                                        spreadRadius: 3,
                                        blurRadius: 1)]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  height(12),
                  Text(
                    "Masuk ke Akun Anda",
                  ),
                  height(24),
                  buildTitle("Email"),
                  height(8),
                  buildTextField(
                    hintText: "contoh@gmail.com",
                    icon: Icon(Icons.email_outlined, color: AppColors.black.withOpacity(0.4)),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong";
                      } else if (!value.contains('@')) {
                        return "Email tidak valid";
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
                      ).hasMatch(value)) {
                        return "Format Email tidak valid";
                      }
                      return null;
                    },
                  ),
              
                  height(16),
                  buildTitle("Kata Sandi"),
                  height(8),
                  buildTextField(
                    hintText: "******",
                    icon: Icon(Icons.lock_outline, color: AppColors.black.withOpacity(0.4)),
                    isPassword: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Kata Sandi tidak boleh kosong";
                      } else if (value.length < 6) {
                        return "Kata Sandi minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  height(1),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                      },
                      child: Text(
                        "Lupa Kata Sandi?",
                        style: TextStyle( color: AppColors.bg1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  height(12),
                  LoginButton(
                    text: "Masuk",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        PreferenceHandler.saveLogin(true);
                        final data = await DBHelper.loginUser(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        if (data != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNav(),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Email atau Kata Sandi salah",
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Validation Error"),
                              content: Text("Please fill all fields"),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
              
              
                  height(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          height: 1,
                          color: AppColors.bg1.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "atau",
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
              
                          height: 1,
                          color: AppColors.bg1.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
              
                  height(16),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
              
              
                        // Navigate to MeetLima screen menggunakan pushnamed
                        Navigator.pushNamed(context, "/meet_2");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google.png",
                            height: 16,
                            width: 16,
                          ),
                          width(4),
                          Text("Google"),
                        ],
                      ),
                    ),
                  ),
                  height(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun?",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistPage(),
                            ),
                          );
              
                        },
                        child: Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                            color: AppColors.bg1,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  TextFormField buildTextField({
    String? hintText,
    bool isPassword = false,
    Icon? icon,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        hintText: hintText,
        prefixIcon: icon,
        fillColor: AppColors.bg1.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.bg1.withOpacity(0.92),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.bg1.withOpacity(0.92)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.bg1,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility, color: AppColors.black.withOpacity(0.4)
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, this.onPressed, required this.text});
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 41,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.shape4.withOpacity(0.75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          text,
          // "Login",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}