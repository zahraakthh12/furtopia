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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      appBar: AppBar(
        title: const Text(
          "Edit Hewan",
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
              buildTextField("Nama Hewan", nameC),
              buildTextField("Jenis Hewan", typeC),
              buildTextField("Jenis Kelamin", genderC),
              buildTextField("Usia", ageC),
              buildTextField("Warna", colorC),
              buildTextField("Berat Badan (kg)", weightC),
              buildTextField("Panjang Badan (cm)", lengthC),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
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
                    Navigator.pop(context, updatedPet);
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
