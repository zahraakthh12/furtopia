import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/pet_model.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  int currentStep = 1;

  final Map<String, dynamic> formData = {
    'icon': '',
    'name': '',
    'type': '',
    'gender': '',
    'age': '',
    'color': '',
    'weight': '',
    'length': '',
  };

  final List<String> petIcons = ['🐱', '🐶', '🐰', '🐹', '🐦', '🐠', '🐢', '🦎'];

  void nextStep() async {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      // 🧩 SIMPAN KE DATABASE
      PetModel pet = PetModel(
        icon: formData['icon'],
        name: formData['name'],
        type: formData['type'],
        gender: formData['gender'],
        age: formData['age'],
        color: formData['color'],
        weight: formData['weight'],
        length: formData['length'],
      );

      await DBHelper.createPet(pet);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hewan peliharaan berhasil ditambahkan 🎉"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Kembali ke PetListScreen
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
          // ==== HEADER ====
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 16),
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

          // ==== STEPPER ====
          buildStepper(),

          // ==== KONTEN PER STEP ====
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

          // ==== BUTTON NAVIGASI ====
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  // ==== STEP SWITCH ====
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

  // ==== STEP 1: PILIH ICON ====
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
                    boxShadow: selected
                        ? [BoxShadow(color: Colors.black26, blurRadius: 6)]
                        : [],
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

  // ==== STEP 2: INFO DASAR ====
  Widget buildBasicInfoStep() {
    return ListView(
      children: [
        buildTextField("Nama Hewan", "name", isRequired: true),
        buildTextField("Jenis Hewan", "type", isRequired: true),
        buildDropdown("Jenis Kelamin", "gender", ["Jantan", "Betina"]),
        buildTextField("Usia", "age", hint: "contoh: 2 tahun"),
      ],
    );
  }

  // ==== STEP 3: DETAIL FISIK ====
  Widget buildPhysicalStep() {
    return ListView(
      children: [
        buildTextField("Berat (kg)", "weight", hint: "contoh: 3.5"),
        buildTextField("Panjang (cm)", "length", hint: "contoh: 25"),
        buildTextField("Warna", "color", hint: "contoh: Putih Abu-abu"),
      ],
    );
  }

  // ==== STEP 4: RINGKASAN ====
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

  // ==== REUSABLE COMPONENTS ====
  Widget buildTextField(String label, String key,
      {String? hint, bool isRequired = false, int maxLines = 1}) {
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
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFB76E79), width: 0.3),
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
      child: DropdownButtonFormField<String>(
        value: formData[key].isEmpty ? null : formData[key],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => formData[key] = v,
      ),
    );
  }

  Widget buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFCE4EC), Color(0xFFFAF5E9)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(formData['icon'], style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formData['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${formData['type']} • ${formData['gender'] ?? '-'}"),
              Text("Usia: ${formData['age']}"),
              Text("Berat: ${formData['weight']} kg, Panjang: ${formData['length']} cm"),
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
                    color: isDone || isActive ? Colors.white : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6)]
                        : [],
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_circle, color: Color(0xFFB76E79))
                        : Text(['🎨', '📝', '📏', '✨'][index],
                            style: TextStyle(
                              fontSize: 20,
                              color: isActive ? const Color(0xFFB76E79) : Colors.white70,
                            )),
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
