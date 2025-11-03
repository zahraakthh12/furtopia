import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/pet_model.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/addpet_screen.dart';
import 'package:furtopia/view/petdetail_screen.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  List<PetModel> petList = [];

  @override
  void initState() {
    super.initState();
    fetchPet();
  }

  // Ambil semua data hewan dari database
  Future<void> fetchPet() async {
    final pet = await DBHelper.getAllPet();
    setState(() {
      petList = pet;
    });
  }

  // Hapus hewan
  Future<void> deletePet(int id) async {
    await DBHelper.deletePet(id);
    fetchPet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar( automaticallyImplyLeading: false,
        backgroundColor: AppColors.shape4,
        title: const Text(
          "Profil Hewan Peliharaan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // 🔹 Konten utama
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 🔹 Tombol tambah
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () async {
                    // Pindah ke halaman tambah dan tunggu hasil
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddPetScreen()),
                    );
                    // Setelah kembali, refresh daftar hewan
                    fetchPet();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.shape4.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Jika belum ada data
              if (petList.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.pets, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "Belum ada hewan peliharaan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // 🔹 Tampilkan daftar hewan
                Expanded(
                  child: ListView.builder(
                    itemCount: petList.length,
                    itemBuilder: (context, index) {
                      final pet = petList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.shape2.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: Text(
                            pet.icon,
                            style: const TextStyle(fontSize: 40),
                          ),
                          title: Text(
                            pet.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${pet.type} • ${pet.age}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info_outline, color: Colors.grey),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PetDetailScreen(pet: pet),),
                                      );
                                      fetchPet();
                                      },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                onPressed: () => deletePet(pet.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
