import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/sql/user_model.dart';
import 'package:furtopia/style/app_colors.dart';

class UserEditProfile extends StatefulWidget {
  final UserModel user;
  const UserEditProfile({super.key, required this.user});

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fullnameC;
  late TextEditingController emailC;
  late TextEditingController phoneC;
  late TextEditingController passwordC;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    fullnameC = TextEditingController(text: user.fullname);
    emailC = TextEditingController(text: user.email);
    phoneC = TextEditingController(text: user.phone);
    passwordC = TextEditingController(text: user.password);
  }

  Future<void> _showConfirmDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Konfirmasi",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Apakah Anda yakin ingin menyimpan perubahan data profil?",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Tutup dialog
              child: const Text(
                "Batal",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog

                final updatedUser = UserModel(
                  id: widget.user.id,
                  fullname: fullnameC.text,
                  email: emailC.text,
                  phone: phoneC.text,
                  password: passwordC.text,
                );

                await DBHelper.updateUser(updatedUser);
                Fluttertoast.showToast(msg: "Data profil berhasil diperbarui");
                Navigator.pop(context, updatedUser); // Kirim kembali ke ProfilePage
              },
              child: const Text(
                "Ya, Simpan",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            fontFamily: 'Poppins',
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
              buildTextField("Nama Lengkap", fullnameC),
              buildTextField("Nomor Telepon", phoneC),
              buildTextField("Email", emailC),
              buildTextField("Password", passwordC),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showConfirmDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB76E79),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontFamily: 'Poppins',
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
          labelStyle: const TextStyle(fontFamily: 'Poppins', color: Color(0xFFB76E79)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v!.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }
}
