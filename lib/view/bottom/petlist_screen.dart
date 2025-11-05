import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/pet_model.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/petdata/addpet_screen.dart';
import 'package:furtopia/view/petdata/petdetail_screen.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  List<PetModel> petList = [];
  final customFont = 'Poppins';

  @override
  void initState() {
    super.initState();
    fetchPet();
  }

  Future<void> fetchPet() async {
    final pet = await DBHelper.getAllPet();
    setState(() {
      petList = pet;
    });
  }

  Future<void> deletePet(int id) async {
    await DBHelper.deletePet(id);
    fetchPet();
  }

  Future<void> showDeleteDialog(PetModel pet) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "🐾 Hapus Hewan?",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFB76E79),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Apakah Anda yakin ingin menghapus hewan '${pet.name}'?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Tombol
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Batal
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFB76E79)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Batal",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFFB76E79),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // Hapus
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await deletePet(pet.id!);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Hapus",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppColors.bg2.withOpacity(0.1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        title: Text(
          "Profil Hewan Peliharaan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Tombol tambah hewan
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddPetScreen()),
                  );
                  fetchPet();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.shape4.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 10),

            // Jika tidak ada hewan
            if (petList.isEmpty)
              Expanded(
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
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              )

            // Jika ada data hewan
            else
              Expanded(
                child: ListView.builder(
                  itemCount: petList.length,
                  itemBuilder: (context, index) {
                    final pet = petList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.shape2.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: Text(
                          pet.icon,
                          style: TextStyle(fontSize: 40),
                        ),
                        title: Text(
                          pet.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        subtitle: Text(
                          "${pet.type} • ${pet.age}",
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // Detail
                            IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.grey),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PetDetailScreen(pet: pet),
                                  ),
                                );
                                fetchPet();
                              },
                            ),

                            // Hapus
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () => showDeleteDialog(pet),
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
    );
  }
}
