import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furtopia/model/firebase/user_firebase_model.dart';
import 'package:furtopia/service/firebase.dart';
import 'package:furtopia/style/app_colors.dart';

class UserEditProfileFirebase extends StatefulWidget {
  final UserFirebaseModel user;
  const UserEditProfileFirebase({super.key, required this.user});

  @override
  State<UserEditProfileFirebase> createState() =>
      _UserEditProfileFirebaseState();
}

class _UserEditProfileFirebaseState extends State<UserEditProfileFirebase> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fullnameC;
  late TextEditingController emailC;
  late TextEditingController phoneC;

  @override
  void initState() {
    super.initState();
    fullnameC = TextEditingController(text: widget.user.fullname ?? "");
    emailC = TextEditingController(text: widget.user.email ?? "");
    phoneC = TextEditingController(text: widget.user.phone ?? "");
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = UserFirebaseModel(
      uid: widget.user.uid,
      fullname: fullnameC.text.trim(),
      email: widget.user.email, // email TIDAK BOLEH DIUBAH
      phone: phoneC.text.trim(),
      createdAt: widget.user.createdAt,
      updateAt: DateTime.now().toIso8601String(),
    );

    try {
      await FirebaseService.updateUser(updatedUser);

      Fluttertoast.showToast(msg: "Data profil berhasil diperbarui");

      Navigator.pop(context, updatedUser);
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal mengupdate profil: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const customFont = 'Poppins';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            fontFamily: customFont,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.6),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama
              buildTextField("Nama Lengkap", fullnameC),

              // Nomor Telepon
              buildTextField("Nomor Telepon", phoneC),

              // Email (readOnly)
              TextFormField(
                controller: emailC,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Email (tidak dapat diubah)",
                  labelStyle: const TextStyle(
                    fontFamily: customFont,
                    color: Color(0xFFB76E79),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB76E79),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontFamily: customFont,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFFB76E79),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v!.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }
}
