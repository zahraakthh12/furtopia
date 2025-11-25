import 'package:flutter/material.dart';
import 'package:furtopia/extensions/navigation.dart';
import 'package:furtopia/model/firebase/user_firebase_model.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:furtopia/service/firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/firebase/login/login_firebase_screen.dart';

//Bahas Shared Preference
class RegistFirebaseScreen extends StatefulWidget {
  const RegistFirebaseScreen({super.key});
  static const id = "/register";
  @override
  State<RegistFirebaseScreen> createState() => _RegistFirebaseScreenState();
}

class _RegistFirebaseScreenState extends State<RegistFirebaseScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final customFont = 'Poppins';
  bool isVisibility = false;
  bool isFilled = false;
  bool isLoading = false;
  UserFirebaseModel user = UserFirebaseModel();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkFields);
    passwordController.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      isFilled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [buildBackground(), buildLayer()]),
    );
  }

  // register() async {
  //   Navigator.push(
  //     context,
  //     MaterialScreenRoute(builder: (context) => HomeScreenDay15()),
  //   );
  // }

  final _formKey = GlobalKey<FormState>();
  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 160,
            bottom: 70,
          ),
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
                  "Mari Bergabung dengan FurTopia!",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: customFont,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                height(12),
                buildTitle("Nama Lengkap"),
                height(5),
                buildTextField(
                  hintText: "Nama Lengkap Anda",
                  icon: Icon(
                    Icons.person_2_outlined,
                    color: AppColors.black.withOpacity(0.4),
                  ),
                  controller: fullnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                height(12),
                buildTitle("Nomor Telepon"),
                height(5),
                buildTextField(
                  hintText: "08xxxxxxxxxx",
                  icon: Icon(
                    Icons.call_outlined,
                    color: AppColors.black.withOpacity(0.4),
                  ),
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor HP tidak boleh kosong';
                    } else if (value.length < 11) {
                      return 'Nomor HP minimal 11 angka';
                    }
                    return null;
                  },
                ),

                height(12),
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
                buildTitle("Password"),
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
                      return "Password tidak boleh kosong";
                    } else if (value.length < 6) {
                      return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),
                height(24),
                LoginButton(
                  text: "Daftar",
                  isLoading: isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final result = await FirebaseService.registerUser(
                          email: emailController.text.trim(),
                          fullname: fullnameController.text.trim(),
                          phone: phoneController.text.trim(),
                          password: passwordController.text,
                        );

                        setState(() {
                          isLoading = false;
                          user = result;
                        });

                        // contoh: simpan token kalau ada
                        if (user.uid != null) {
                          await PreferenceHandler.saveToken(user.uid!);

                          Fluttertoast.showToast(
                            msg: "Registrasi berhasil! Silakan login.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: AppColors.shape4.withOpacity(0.4),
                            textColor: AppColors.black,
                            fontSize: 14,
                          );
                        }

                        context.pushReplacement(LoginFirebaseScreen());
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Validasi Error"),
                            content: const Text("Silakan isi semua kolom"),
                            actions: [
                              TextButton(
                                child: const Text("Ok"),
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

                height(5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: TextStyle(fontFamily: customFont, fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Masuk di sini",
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
          image: AssetImage(AppImages.background2),
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
        hintStyle: TextStyle(
          fontSize: 12,
          color: AppColors.black.withOpacity(0.5),
          fontFamily: customFont,
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
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.black.withOpacity(0.4),
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
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            fontFamily: customFont,
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading,
  });
  final void Function()? onPressed;
  final String text;
  final customFont = 'Poppins';
  final bool? isLoading;
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
        child: isLoading == true
            ? CircularProgressIndicator()
            : Text(
                text,
                // "Login",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: customFont,
                ),
              ),
      ),
    );
  }
}
