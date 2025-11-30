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
      setState(() => currentStep++); // lanjut ke langkah berikutnya
      return; // keluar dari fungsi
    }
 
    // validasi data formulir sebelum menyimpan
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
      await PetFirebaseService.createPet(newPet); // simpan data hewan peliharaan ke Firebase

      Fluttertoast.showToast(
        msg: "Hewan peliharaan berhasil ditambahkan 🎉",
        backgroundColor: AppColors.shape3,
        textColor: AppColors.black,
      );

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal menambahkan hewan: $e", // tampilkan pesan kesalahan jika gagal
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void prevStep() {
    if (currentStep > 1) setState(() => currentStep--); // kembali ke langkah sebelumnya
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
                  onPressed: () => Navigator.pop(context), // kembali ke halaman sebelumnya
                ),
                const Text(
                  "Tambah Hewan Peliharaan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          buildStepper(), // tampilkan stepper di bagian atas

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400), 
              child: Padding(
                key: ValueKey(currentStep),
                padding: const EdgeInsets.all(20),
                child: buildStepContent(), // tampilkan konten langkah saat ini
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                if (currentStep > 1) // tampilkan tombol "Kembali" jika bukan langkah pertama
                  Expanded(
                    child: OutlinedButton(
                      onPressed: prevStep, // kembali ke langkah sebelumnya
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB76E79)),
                        foregroundColor: const Color(0xFFB76E79),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Kembali"),
                    ),
                  ),
                if (currentStep > 1) const SizedBox(width: 10), // tambahkan jarak antara tombol, jika ada tombol "Kembali"

                Expanded(
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB76E79),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      currentStep == 4 ? "Tambah Hewan" : "Lanjut", // ubah teks tombol berdasarkan langkah saat ini
                      style: const TextStyle(
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

  // menampilkan konten berdasarkan langkah saat ini
  Widget buildStepContent() {
    switch (currentStep) { // tentukan konten berdasarkan langkah saat ini
      case 1:
        return buildIconStep(); // langkah pemilihan ikon
      case 2:
        return buildBasicInfoStep(); // langkah informasi dasar
      case 3:
        return buildPhysicalStep(); // langkah detail fisik
      case 4:
        return buildSummaryStep(); // langkah tinjau data
      default:
        return const SizedBox(); // jika langkah tidak valid, tampilkan kotak kosong
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
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: petIcons.map((icon) { // buat grid ikon hewan peliharaan
              final selected = formData['icon'] == icon; // periksa apakah ikon saat ini dipilih
              return GestureDetector(
                onTap: () => setState(() => formData['icon'] = icon), // perbarui ikon yang dipilih saat diketuk
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                          )
                        : null, // jika tidak dipilih, tidak ada gradien
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
            }).toList(), // konversi daftar ikon menjadi widget
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
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        buildSummaryCard(), // tampilkan kartu ringkasan data hewan peliharaan
      ],
    );
  }

  // widget untuk membuat field teks
  Widget buildTextField(String label, String key,
      {String? hint, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label${isRequired ? ' *' : ''}", // tambahkan tanda bintang jika wajib diisi
              style: const TextStyle(
                color: Color(0xFFB76E79),
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          TextField(
            controller: TextEditingController(text: formData[key]), // atur nilai awal dari formData
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (v) => formData[key] = v, // perbarui formData saat teks berubah
          ),
        ],
      ),
    );
  }

  // widget untuk membuat dropdown
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
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>( // buat dropdown
            value: formData[key].isEmpty ? null : formData[key], // atur nilai awal dari formData
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: items // buat item dropdown dari daftar yang diberikan
                .map((e) => DropdownMenuItem(value: e, child: Text(e))) 
                .toList(), // konversi daftar item menjadi widget
            onChanged: (v) => formData[key] = v, // perbarui formData saat pilihan berubah
          ),
        ],
      ),
    );
  }

  // widget untuk menampilkan kartu ringkasan data hewan peliharaan
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

  // widget untuk menampilkan stepper di bagian atas layar
  Widget buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final step = index + 1; // langkah saat ini (1-4)
          final isDone = currentStep > step; // periksa apakah langkah sudah selesai
          final isActive = currentStep == step; // periksa apakah langkah saat ini aktif

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDone || isActive // jika langkah sudah selesai atau aktif
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: isActive // jika langkah saat ini aktif
                        ? [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6)
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isDone // jika langkah sudah selesai
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
