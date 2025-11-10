import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/pet_model.dart';
import 'package:furtopia/style/app_colors.dart';

class PetEditScreen extends StatefulWidget {
  final PetModel pet;
  const PetEditScreen({super.key, required this.pet});

  @override
  State<PetEditScreen> createState() => _PetEditScreenState();
}

class _PetEditScreenState extends State<PetEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameC;
  late TextEditingController typeC;
  late TextEditingController genderC;
  late TextEditingController ageC;
  late TextEditingController colorC;
  late TextEditingController weightC;
  late TextEditingController lengthC;

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    nameC = TextEditingController(text: pet.name);
    typeC = TextEditingController(text: pet.type);
    genderC = TextEditingController(text: pet.gender);
    ageC = TextEditingController(text: pet.age);
    colorC = TextEditingController(text: pet.color);
    weightC = TextEditingController(text: pet.weight);
    lengthC = TextEditingController(text: pet.length);
  }

  void showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Konfirmasi",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Apakah Anda yakin ingin menyimpan perubahan data hewan ini?",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // batal
              child: Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4.withOpacity(0.6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.pop(context); // tutup dialog

                final updatedPet = PetModel(
                  id: widget.pet.id,
                  icon: widget.pet.icon,
                  name: nameC.text,
                  type: typeC.text,
                  gender: genderC.text,
                  age: ageC.text,
                  color: colorC.text,
                  weight: weightC.text,
                  length: lengthC.text,
                );

                await DBHelper.updatePet(updatedPet);

                Fluttertoast.showToast(msg: "Data hewan berhasil diperbarui");
                Navigator.pop(context, updatedPet); // kembali ke detail
              },
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF5E9),
      appBar: AppBar(
        title: Text(
          "Edit Data Hewan",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField("Nama Hewan", nameC),
              buildTextField("Jenis Hewan", typeC),
              buildTextField("Jenis Kelamin", genderC),
              buildTextField("Usia", ageC),
              buildTextField("Warna", colorC),
              buildTextField("Berat Badan (kg)", weightC),
              buildTextField("Panjang Badan (cm)", lengthC),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showConfirmDialog(); // memunculkan dialog konfirmasi
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shape4.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
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
          labelStyle: TextStyle(fontFamily: 'Poppins', color: AppColors.shape4.withOpacity(0.6)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v!.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }
}
