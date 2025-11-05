import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/user_model.dart';
import 'package:furtopia/style/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.user.fullname);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _passwordController = TextEditingController(text: widget.user.password);
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = UserModel(
        id: widget.user.id,
        fullname: _fullnameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
      );

      await DBHelper.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );

      Navigator.pop(context, updatedUser); // kirim data balik ke ProfilePage
    }
  }

  @override
  Widget build(BuildContext context) {
    final customFont = 'Poppins';
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil",
            style: TextStyle(
                color: AppColors.white,
                fontFamily: customFont,
                fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.shape5.withOpacity(0.75),
      ), backgroundColor: AppColors.bg1.withOpacity(0.1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _fullnameController,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
              validator: (value) =>
                  value!.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (value) =>
                  value!.isEmpty ? 'Email tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Nomor Telepon"),
              validator: (value) =>
                  value!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Kata Sandi"),
              validator: (value) =>
                  value!.isEmpty ? 'Kata sandi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4.withOpacity(0.75),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _saveProfile,
              child: Text("Simpan Perubahan",
                  style: TextStyle(
                      fontFamily: customFont,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white)),
            ),
          ]),
        ),
      ),
    );
  }
}
