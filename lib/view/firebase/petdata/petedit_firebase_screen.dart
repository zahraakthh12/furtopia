import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/service/pet_firebase.dart';
import 'package:furtopia/style/app_colors.dart';

class PetEditFirebaseScreen extends StatefulWidget {
  final PetFirebaseModel pet; // Data hewan peliharaan yang akan diedit
  const PetEditFirebaseScreen({super.key, required this.pet});

  @override
  State<PetEditFirebaseScreen> createState() => _PetEditFirebaseScreenState();
}

class _PetEditFirebaseScreenState extends State<PetEditFirebaseScreen> {
  final _formKey = GlobalKey<FormState>(); // Key untuk form validasi

  // Controller untuk setiap field input
  late TextEditingController nameC;
  late TextEditingController typeC;
  late TextEditingController genderC;
  late TextEditingController ageC;
  late TextEditingController colorC;
  late TextEditingController weightC;
  late TextEditingController lengthC;

  @override
  // Inisialisasi controller dengan data hewan yang akan diedit
  void initState() {
    super.initState();
    final pet = widget.pet;
    nameC = TextEditingController(text: pet.name ?? "");
    typeC = TextEditingController(text: pet.type ?? "");
    genderC = TextEditingController(text: pet.gender ?? "");
    ageC = TextEditingController(text: pet.age ?? "");
    colorC = TextEditingController(text: pet.color ?? "");
    weightC = TextEditingController(text: pet.weight ?? "");
    lengthC = TextEditingController(text: pet.length ?? "");
  }

  // Menampilkan dialog konfirmasi sebelum menyimpan perubahan
  void showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Konfirmasi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Apakah Anda yakin ingin menyimpan perubahan data hewan ini?"
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Simpan perubahan data hewan peliharaan
              onPressed: () async {
                Navigator.pop(context);

                // Buat objek PetFirebaseModel dengan data yang diperbarui
                final updatedPet = PetFirebaseModel(
                  uid: widget.pet.uid,
                  ownerId: widget.pet.ownerId,
                  icon: widget.pet.icon,
                  name: nameC.text,
                  type: typeC.text,
                  gender: genderC.text,
                  age: ageC.text,
                  color: colorC.text,
                  weight: weightC.text,
                  length: lengthC.text,
                  createdAt: widget.pet.createdAt,
                  updateAt: DateTime.now().toIso8601String(), // Perbarui timestamp
                );

                try {
                  await PetFirebaseService.updatePet(updatedPet); // panggil service untuk update data

                  if (!mounted) return; // jika widget sudah tidak ada, hentikan eksekusi
                  Fluttertoast.showToast(msg: "Data hewan berhasil diperbarui");

                  if (mounted) Navigator.pop(context, updatedPet); // Kembali ke layar sebelumnya dengan mengirim data hewan yang diperbarui
                } catch (e) { // Tangani error jika update gagal
                  Fluttertoast.showToast(msg: "Gagal update: $e");
                }
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
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
          "Edit Data Hewan",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Gunakan form key untuk validasi
          child: ListView(
            children: [
              buildTextField("Nama Hewan", nameC),
              buildTextField("Jenis Hewan", typeC),
              buildTextField("Jenis Kelamin", genderC),
              buildTextField("Usia", ageC),
              buildTextField("Warna", colorC),
              buildTextField("Berat Badan (kg)", weightC),
              buildTextField("Panjang Badan (cm)", lengthC),

              const SizedBox(height: 10),

              ElevatedButton(
                // Simpan perubahan data hewan peliharaan
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showConfirmDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shape4.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
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

  // widget untuk membuat field input teks dengan label
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.shape4.withOpacity(0.6),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v!.isEmpty ? "$label tidak boleh kosong" : null, // Validasi input tidak boleh kosong
      ),
    );
  }
}
