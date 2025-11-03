//Bahas Shared Preference
import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
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
  final customFont = 'Poppins';
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
          padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 25),
          child: Container(padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(30), 
                  boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25), 
                                        offset: Offset(2, 2), 
                                        spreadRadius: 3,
                                        blurRadius: 1)]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: customFont),
                ),
                Text(
                  "Masuk ke Akun Anda", style:TextStyle(fontSize: 12, fontFamily: customFont)
                ),
                height(12),
                buildTitle("Email"),
                height(5),
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
            
                height(12),
                buildTitle("Kata Sandi"),
                height(5),
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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                    },
                    child: Text(
                      "Lupa Kata Sandi?",
                      style: TextStyle( color: AppColors.bg1,
                        fontSize: 12,
                        fontFamily: customFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

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
                      "atau", style: TextStyle(fontFamily: customFont, fontSize: 12),
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
            
                height(12),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/google.png",
                        height: 40,
                        width: 40,
                      ),
                      width(30),
                      Image.asset(
                        "assets/images/wa.png",
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ),
                height(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?", style: TextStyle(fontFamily: customFont, fontSize: 12)
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
                          fontSize: 12,
                          fontFamily: customFont,
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
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.bg1),
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
      style: TextStyle(fontFamily: customFont, fontSize: 12),
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.5), fontFamily: customFont),
        prefixIcon: icon,
        fillColor: AppColors.bg1.withOpacity(0.35),
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
        Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontFamily: customFont ))
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, this.onPressed, required this.text});
  final void Function()? onPressed;
  final String text;
  final customFont = 'Poppins';
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: customFont
          ),
        ),
      ),
    );
  }
}