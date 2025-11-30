import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/service/pet_firebase.dart';
import 'package:furtopia/style/app_colors.dart';

class AddPetFirebaseScreen extends StatefulWidget {
  const AddPetFirebaseScreen({super.key});

  @override
  State<AddPetFirebaseScreen> createState() => _AddPetFirebaseScreenState();
}

class _AddPetFirebaseScreenState extends State<AddPetFirebaseScreen> {
  int currentStep = 1; // langkah saat ini dalam proses penambahan hewan peliharaan

  final Map<String, dynamic> formData = {
    'icon': '',
    'name': '',
    'type': '',
    'gender': '',
    'age': '',
    'color': '',
    'weight': '',
    'length': '',
  }; // menyimpan data formulir hewan peliharaan

  final uid = FirebaseAuth.instance.currentUser!.uid; // dapatkan UID pengguna saat ini

  final List<String> petIcons = ['🐱', '🐶', '🐰', '🐹', '🐦', '🐠', '🐢', '🦎']; // daftar ikon hewan peliharaan

  // fungsi untuk melanjutkan ke langkah berikutnya atau menyimpan data hewan peliharaan
  void nextStep() async {
    if (currentStep < 4) {
      setState(() => currentStep++);
      return; // untuk 
    }
 
    final newPet = PetFirebaseModel(
      ownerId: uid,
      icon: formData["icon"],
      name: formData["name"],
      type: formData["type"],
      gender: formData["gender"],
      age: formData["age"],
      color: formData["color"],
      weight: formData["weight"],
      length: formData["length"],
    );

    try {
      await PetFirebaseService.createPet(newPet);

      Fluttertoast.showToast(
        msg: "Hewan peliharaan berhasil ditambahkan 🎉",
        backgroundColor: AppColors.shape3,
        textColor: AppColors.black,
      );

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal menambahkan hewan: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void prevStep() {
    if (currentStep > 1) setState(() => currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Tambah Hewan Peliharaan",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          buildStepper(),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                key: ValueKey(currentStep),
                padding: const EdgeInsets.all(20),
                child: buildStepContent(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                if (currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: prevStep,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB76E79)),
                        foregroundColor: const Color(0xFFB76E79),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Kembali"),
                    ),
                  ),
                if (currentStep > 1) const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB76E79),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      currentStep == 4 ? "Tambah Hewan" : "Lanjut",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStepContent() {
    switch (currentStep) {
      case 1:
        return buildIconStep();
      case 2:
        return buildBasicInfoStep();
      case 3:
        return buildPhysicalStep();
      case 4:
        return buildSummaryStep();
      default:
        return const SizedBox();
    }
  }

  // STEP 1 — pilih icon
  Widget buildIconStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih Icon Hewan 🎨",
          style: TextStyle(
            color: Color(0xFFB76E79),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: petIcons.map((icon) {
              final selected = formData['icon'] == icon;
              return GestureDetector(
                onTap: () => setState(() => formData['icon'] = icon),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                          )
                        : null,
                    color: selected ? null : const Color(0xFFFCE4EC),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:
                        selected ? [BoxShadow(color: Colors.black26, blurRadius: 6)] : [],
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 32)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // STEP 2 — basic info
  Widget buildBasicInfoStep() {
    return ListView(
      children: [
        buildTextField("Nama Hewan", "name", isRequired: true),
        buildTextField("Jenis Hewan", "type",
            hint: "contoh: Kucing, Anjing", isRequired: true),
        buildDropdown("Jenis Kelamin", "gender", ["Jantan", "Betina"]),
        buildTextField("Usia", "age", hint: "contoh: 2 tahun"),
      ],
    );
  }

  // STEP 3 — detail fisik
  Widget buildPhysicalStep() {
    return ListView(
      children: [
        buildTextField("Berat Badan (kg)", "weight", hint: "contoh: 3.5"),
        buildTextField("Panjang Badan (cm)", "length", hint: "contoh: 25"),
        buildTextField("Warna", "color", hint: "contoh: Putih Abu-abu"),
      ],
    );
  }

  // STEP 4 — summary
  Widget buildSummaryStep() {
    return ListView(
      children: [
        const Text(
          "Tinjau Data Hewan",
          style: TextStyle(
            color: Color(0xFFB76E79),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        buildSummaryCard(),
      ],
    );
  }

  // === FORM FIELD REUSABLE ===
  Widget buildTextField(String label, String key,
      {String? hint, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label${isRequired ? ' *' : ''}",
              style: const TextStyle(
                color: Color(0xFFB76E79),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          TextField(
            controller: TextEditingController(text: formData[key]),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (v) => formData[key] = v,
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, String key, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label *",
            style: const TextStyle(
              color: Color(0xFFB76E79),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: formData[key].isEmpty ? null : formData[key],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => formData[key] = v,
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: [Color(0xFFFCE4EC), Color(0xFFFAF5E9)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(formData['icon'], style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formData['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${formData['type']} • ${formData['gender'] ?? '-'}"),
              Text("Usia: ${formData['age']}"),
              Text("Berat: ${formData['weight']} kg"),
              Text("Panjang: ${formData['length']} cm"),
              Text("Warna: ${formData['color']}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final step = index + 1;
          final isDone = currentStep > step;
          final isActive = currentStep == step;

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDone || isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6)
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFFB76E79))
                        : Text(
                            ['🎨', '📝', '📏', '✨'][index],
                            style: TextStyle(
                                fontSize: 20,
                                color: isActive
                                    ? const Color(0xFFB76E79)
                                    : Colors.white70),
                          ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
