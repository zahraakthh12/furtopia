import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/user_firebase_model.dart';
import 'package:furtopia/service/firebase.dart';
import 'package:furtopia/style/app_colors.dart';

class EditProfileFirebaseScreen extends StatefulWidget {
  final UserFirebaseModel user;

  const EditProfileFirebaseScreen({super.key, required this.user});

  @override
  State<EditProfileFirebaseScreen> createState() =>
      _EditProfileFirebaseScreenState();
}

class _EditProfileFirebaseScreenState
    extends State<EditProfileFirebaseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _fullnameController =
        TextEditingController(text: widget.user.fullname ?? "");
    _emailController = TextEditingController(text: widget.user.email ?? "");
    _phoneController = TextEditingController(text: widget.user.phone ?? "");
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = UserFirebaseModel(
      uid: widget.user.uid,
      fullname: _fullnameController.text,
      email: widget.user.email, // Email tidak diubah
      phone: _phoneController.text,
      createdAt: widget.user.createdAt,
      updateAt: DateTime.now().toIso8601String(),
    );

    await FirebaseService.updateUser(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final customFont = 'Poppins';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profil",
          style: TextStyle(
              color: AppColors.white,
              fontFamily: customFont,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape5.withOpacity(0.75),
      ),
      backgroundColor: AppColors.bg1.withOpacity(0.1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // FULLNAME
              TextFormField(
                controller: _fullnameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),

              // EMAIL (readonly)
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Email (tidak bisa diubah)",
                ),
              ),

              // PHONE
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Nomor Telepon"),
                validator: (value) =>
                    value!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
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
                child: Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                      fontFamily: customFont,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
