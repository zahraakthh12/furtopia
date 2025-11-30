import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/view/firebase/petdata/petedit_firebase_screen.dart';

class PetDetailFirebaseScreen extends StatefulWidget {
  final PetFirebaseModel pet; // Data hewan peliharaan yang akan ditampilkan
  const PetDetailFirebaseScreen({super.key, required this.pet});

  @override
  State<PetDetailFirebaseScreen> createState() =>
      _PetDetailFirebaseScreenState();
}

class _PetDetailFirebaseScreenState extends State<PetDetailFirebaseScreen> {
  int selectedTab = 0; // Tab yang sedang dipilih (0: Informasi, 1: Kesehatan)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
                ),
                const Text(
                  "Profil Hewan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Bagian konten utama 
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(widget.pet.icon ?? "",
                        style: const TextStyle(fontSize: 64)),
                    const SizedBox(height: 8),
                    Text(
                      widget.pet.name ?? "",
                      style: const TextStyle(
                        color: Color(0xFFB76E79),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          buildTabButton("Informasi", 0),
                          buildTabButton("Kesehatan", 1),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (selectedTab == 0) buildInfoSection(), // Tampilkan bagian informasi
                    if (selectedTab == 1) buildHealthSection(), // Tampilkan bagian kesehatan
                  ],
                ),
              ),
            ),
          ),

          // Bagian tombol di bawah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                    label: const Text(
                      "Booking",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB76E79),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Edit button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PetEditFirebaseScreen(pet: widget.pet), // Navigasi ke layar edit hewan peliharaan dengan data hewan saat ini
                        ),
                      ).then((updatedPet) { // Terima data hewan yang diperbarui setelah kembali dari layar edit
                        if (updatedPet != null &&
                            updatedPet is PetFirebaseModel) {
                          setState(() {
                            widget.pet.name = updatedPet.name;
                            widget.pet.type = updatedPet.type;
                            widget.pet.gender = updatedPet.gender;
                            widget.pet.age = updatedPet.age;
                            widget.pet.color = updatedPet.color;
                            widget.pet.weight = updatedPet.weight;
                            widget.pet.length = updatedPet.length;
                            widget.pet.icon = updatedPet.icon;
                          });
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFB76E79)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB76E79),
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

  // Widget untuk membuat tombol tab aktif
  Widget buildTabButton(String title, int index) {
    final isActive = selectedTab == index; // Periksa apakah tab ini aktif
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index), // Ubah tab yang dipilih saat ditekan
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? const Color(0xFFB76E79) : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan bagian informasi hewan peliharaan
  Widget buildInfoSection() {
    final pet = widget.pet; 

    return Column(
      children: [
        buildInfoBox("Jenis", pet.type ?? "-"),
        buildInfoBox("Jenis Kelamin", pet.gender ?? "-"),
        buildInfoBox("Usia", pet.age ?? "-"),
        buildInfoBox("Warna", pet.color ?? "-"),
        buildInfoBox("Berat Badan", "${pet.weight ?? '-'} kg"),
        buildInfoBox("Panjang Badan", "${pet.length ?? '-'} cm"),
      ],
    );
  }

  // widget untuk menampilkan kotak informasi pet
  Widget buildInfoBox(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB76E79))),
        ],
      ),
    );
  }

  // Widget untuk menampilkan bagian kesehatan hewan peliharaan
  Widget buildHealthSection() {
    return const Center(
      child: Text(
        "Belum ada data kesehatan 🩺",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
