import 'package:firebase_auth/firebase_auth.dart'; // untuk autentikasi Firebase
import 'package:flutter/material.dart'; // untuk widget Flutter
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/service/pet_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/firebase/petdata/addpet_firebase_screen.dart';
import 'package:furtopia/view/firebase/petdata/petdetailt_firebase_screen.dart';

class PetListFirebaseScreen extends StatefulWidget {
  const PetListFirebaseScreen({super.key});

  @override
  State<PetListFirebaseScreen> createState() => _PetListFirebaseScreenState();
}

class _PetListFirebaseScreenState extends State<PetListFirebaseScreen> {
  List<PetFirebaseModel> petList = []; // list data hewan dari firebase

  @override
  // menginisialisasi state dan memanggil fetchPets
  void initState() {
    super.initState();
    fetchPets();
  }

  // mengambil data hewan dari Firebase berdasarkan ID pemilik
  Future<void> fetchPets() async {
    final uid = FirebaseAuth.instance.currentUser!.uid; // ambil UID user saat ini
    final pets = await PetFirebaseService.getPetsByOwner(uid); // ambil data hewan berdasarkan UID pemilik 

    // perbarui state dengan data hewan yang diambil
    setState(() {
      petList = pets;
    });
  }

  // menghapus data hewan dari Firebase
  Future<void> deletePet(String uid) async {
    await PetFirebaseService.deletePet(uid);
    fetchPets();
  }

  // menampilkan dialog konfirmasi penghapusan
  Future<void> showDeleteDialog(PetFirebaseModel pet) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "🐾 Hapus Hewan?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: const Color(0xFFB76E79),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Apakah Anda yakin ingin menghapus hewan '${pet.name}'?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    // cancek
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFB76E79)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Color(0xFFB76E79)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // hapus
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // tutup dialog
                          await deletePet(pet.uid!); // hapus hewan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Hapus",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg2.withOpacity(0.1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        title: Text(
          "Profil Hewan Peliharaan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      body: Stack(
        children: [
          buildBackground(), // menumpuk background dan konten

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // button add pet
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddPetFirebaseScreen(), // menuju halaman tambah hewan
                        ),
                      );
                      fetchPets(); // refresh list hewan setelah kembali dari halaman tambah hewan
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

                // halaman list hewan jika kosong
                if (petList.isEmpty)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.pets, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "Belum ada hewan peliharaan",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )

                // halaman list hewan jika ada data
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: petList.length,
                      itemBuilder: (context, index) {
                        final pet = petList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.85,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: Text(
                              pet.icon ?? "🐾",
                              style: const TextStyle(fontSize: 40),
                            ),
                            title: Text(
                              pet.name ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "${pet.type ?? ''} • ${pet.age ?? ''}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PetDetailFirebaseScreen(pet: pet), // menuju halaman detail hewan 
                                      ),
                                    );
                                    fetchPets(); // refresh list hewan setelah kembali dari halaman detail hewan
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => showDeleteDialog(pet), // tampilkan dialog konfirmasi hapus
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
        ],
      ),
    );
  }

  // membuat background
  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background4),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
