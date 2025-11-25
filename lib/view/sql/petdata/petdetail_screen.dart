import 'package:flutter/material.dart';
import 'package:furtopia/model/pet_model.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/sql/petdata/petedit_screen.dart';

class PetDetailScreen extends StatefulWidget {
  final PetModel pet;
  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  int selectedTab = 0; // 0 = Informasi, 1 = Kesehatan

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      body: Column(
        children: [
          // ==== HEADER ====
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Profil Hewan",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

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
                    Text(
                      pet.icon,
                      style: const TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pet.name,
                      style: const TextStyle(
                        color: Color(0xFFB76E79),
                        fontFamily: 'Poppins',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildTabButton("Informasi", 0),
                          buildTabButton("Kesehatan", 1),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (selectedTab == 0) buildInfoSection(pet), //Jika selectedTab bernilai 0, maka tampilkan widget buildInfo
                    if (selectedTab == 1) buildHealthSection(),
                  ],
                ),
              ),
            ),
          ),

          // Membuat button booking dan edit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: const Text("Booking",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB76E79),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => PetEditScreen(pet: pet),)
                        ).then((updatedPet) {
                          if (updatedPet != null && updatedPet is PetModel) {
                            setState(() {
                              widget.pet.name = updatedPet.name;
                              widget.pet.type = updatedPet.type;
                              widget.pet.gender = updatedPet.gender;
                              widget.pet.age = updatedPet.age;
                              widget.pet.color = updatedPet.color;
                              widget.pet.weight = updatedPet.weight;
                              widget.pet.length = updatedPet.length;
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
                        fontFamily: 'Poppins',
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

  Widget buildTabButton(String label, int index) {
    final isActive = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? const Color(0xFFB76E79) : Colors.grey,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoSection(PetModel pet) {
    return Column(
      children: [
        buildInfoBox("Jenis", pet.type),
        buildInfoBox("Jenis Kelamin", pet.gender),
        buildInfoBox("Usia", pet.age),
        buildInfoBox("Warna", pet.color),
        buildInfoBox("Berat Badan", "${pet.weight} kg"),
        buildInfoBox("Panjang Badan", "${pet.length} cm"),
      ],
    );
  }

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
                  fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Colors.black54)),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color(0xFFB76E79))),
        ],
      ),
    );
  }

  Widget buildHealthSection() {
    return const Center(
      child: Text(
        "Belum ada data kesehatan 🩺",
        style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
      ),
    );
  }
}
