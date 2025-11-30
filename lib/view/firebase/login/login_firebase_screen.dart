import 'package:flutter/material.dart';  // untuk widget Flutter
import 'package:furtopia/navigation/bottom_nav_firebase.dart';
import 'package:furtopia/service/firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:fluttertoast/fluttertoast.dart'; // untuk menampilkan toast
import 'package:furtopia/view/firebase/login/regist_firebase_screen.dart';

class LoginFirebaseScreen extends StatefulWidget {
  const LoginFirebaseScreen({super.key});
  static const id = "/login_screen18"; // identifier untuk route
  @override
  State<LoginFirebaseScreen> createState() => _LoginFirebaseScreenState();
}

class _LoginFirebaseScreenState extends State<LoginFirebaseScreen> {
  final TextEditingController emailController = TextEditingController(); // controller untuk input email 
  final TextEditingController passwordController = TextEditingController(); // controller untuk input password
  bool isVisibility = false; // untuk mengatur visibilitas password
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // menghindari resize saat keyboard muncul
      body: Stack(children: [buildBackground(), buildLayer()]), // menumpuk background dan layer utama
    );
  }

  // untuk proses login
  // login() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => BottomNavFirebase()), // navigasi ke BottomNav setelah login
  //   );
  // }

  final _formKey = GlobalKey<FormState>(); // key untuk form validasi
  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 25),
          child: Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.25),
                  offset: Offset(2, 2),
                  spreadRadius: 3,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Masuk ke Akun Anda",
                  style: TextStyle(fontSize: 12),
                ),
                height(12),

                // Email TextField
                buildTitle("Email"),
                height(5),
                buildTextField(
                  hintText: "contoh@gmail.com",
                  icon: Icon(
                    Icons.email_outlined,
                    color: AppColors.black.withOpacity(0.4),
                  ),
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

                // Password TextField
                buildTitle("Kata Sandi"),
                height(5),
                buildTextField(
                  hintText: "******",
                  icon: Icon(
                    Icons.lock_outline,
                    color: AppColors.black.withOpacity(0.4),
                  ),
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

                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {},
                //     child: Text(
                //       "Lupa Kata Sandi?",
                //       style: TextStyle(
                //         color: AppColors.bg1,
                //         fontSize: 12,
                //         fontFamily: customFont,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
                height(20),

                // Tombol Login
                LoginButton(
                  text: "Login",
                  onPressed: () async {
                    // proses validasi form
                    if (_formKey.currentState!.validate()) {
                      print(emailController.text);
                      PreferenceHandler.saveLogin(true); // menyimpan status login
                      final data = await FirebaseService.loginUser(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      print(data);
                      // jika login berhasil
                      if (data != null) {
                        PreferenceHandler.saveToken(data.uid.toString()); // menyimpan token user
                        Fluttertoast.showToast(
                          msg: "Login berhasil! Selamat datang 👋",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: AppColors.shape4.withOpacity(0.4),
                          textColor: AppColors.black,
                          fontSize: 14,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavFirebase(), // navigasi ke BottomNavFirebase setelah login
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Email atau password salah",
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Validasi Error"),
                            content: Text("Silakan isi semua kolom"),
                            actions: [
                              TextButton(
                                child: Text("Ok"),
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

                // height(16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Container(
                //         margin: EdgeInsets.only(right: 8),
                //         height: 1,
                //         color: AppColors.bg1.withOpacity(0.5),
                //       ),
                //     ),
                //     Text(
                //       "atau",
                //       style: TextStyle(fontFamily: customFont, fontSize: 12),
                //     ),
                //     Expanded(
                //       child: Container(
                //         margin: EdgeInsets.only(left: 8),
                //         height: 1,
                //         color: AppColors.bg1.withOpacity(0.5),
                //       ),
                //     ),
                //   ],
                // ),
                height(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistFirebaseScreen(), // navigasi ke halaman registrasi
                          ),
                        );
                      },
                      child: Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          color: AppColors.bg1,
                          fontSize: 12,
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

  // membuat background
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

  // membuat text field
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
      obscureText: isPassword ? !isVisibility : false,
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          color: AppColors.black.withOpacity(0.5),
        ),
        prefixIcon: icon,
        fillColor: AppColors.bg1.withOpacity(0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.bg1.withOpacity(0.92)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.bg1.withOpacity(0.92)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.bg1),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility; 
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.black.withOpacity(0.4),
                ),
              )
            : null, // jika bukan password, tidak ada suffix icon
      ),
    );
  }

  // membuat SizedBox untuk jarak
  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  // membuat judul text field
  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// membuat tombol login
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
