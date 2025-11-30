import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/user_firebase_model.dart';
import 'package:furtopia/service/firebase.dart';
import 'package:furtopia/style/app_colors.dart';

class EditProfileFirebaseScreen extends StatefulWidget {
  final UserFirebaseModel user; // data user yang akan diedit

  const EditProfileFirebaseScreen({super.key, required this.user});

  @override
  State<EditProfileFirebaseScreen> createState() =>
      _EditProfileFirebaseScreenState();
}

class _EditProfileFirebaseScreenState extends State<EditProfileFirebaseScreen> {
  final _formKey = GlobalKey<FormState>(); // key untuk validasi form

  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState(); // inisialisasi state

    // inisialisasi controller dengan data user yang diterima dari widget
    _fullnameController = TextEditingController(text: widget.user.fullname);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address ?? "");
  }

  // fungsi untuk menyimpan perubahan profil
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = UserFirebaseModel(
      uid: widget.user.uid,
      fullname: _fullnameController.text,
      email: widget.user.email,
      phone: _phoneController.text,
      address: _addressController.text,
      createdAt: widget.user.createdAt,
      updateAt: DateTime.now().toIso8601String(),
    );

    await FirebaseService.updateUser(updated);  // simpan perubahan ke Firestore

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );

    Navigator.pop(context, updated); // kembali ke layar sebelumnya dengan data user yang diperbarui
  }

  // fungsi untuk membangun field input
  InputDecoration buildField(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.shape5.withOpacity(0.75),
        title: Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullnameController,
                decoration: buildField("Nama Lengkap"),
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                decoration: buildField("Nomor Telepon"),
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: buildField("Email (tidak dapat diubah)"),
              ),
              SizedBox(height: 15),

              TextFormField(
                controller: _addressController,
                decoration: buildField(
                  "Alamat Lengkap (Jalan, No. Rumah, Kelurahan)",
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveProfile, // panggil fungsi simpan perubahan
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shape4,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Simpan Perubahan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
