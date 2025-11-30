import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/service/pet_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petclinic/choose_clinic_screen.dart';

class PetChooseFirebaseScreen extends StatefulWidget {
  const PetChooseFirebaseScreen({super.key});

  @override
  State<PetChooseFirebaseScreen> createState() =>
      _PetChooseFirebaseScreenState();
}

class _PetChooseFirebaseScreenState extends State<PetChooseFirebaseScreen> {
  List<PetFirebaseModel> petList = []; // daftar hewan peliharaan yang diambil dari Firebase

  @override
  // init state untuk memulai pengambilan data hewan peliharaan saat layar dibuat
  void initState() {
    super.initState();
    fetchPets(); // panggil fetchPets untuk mengambil data hewan peliharaan
  }

  // fungsi untuk mengambil data hewan peliharaan dari Firebase
  Future<void> fetchPets() async {
    final uid = FirebaseAuth.instance.currentUser!.uid; // dapatkan UID pengguna saat ini
    final pets = await PetFirebaseService.getPetsByOwner(uid); // ambil data hewan peliharaan berdasarkan UID pemilik

    setState(() {
      petList = pets; // perbarui state dengan data hewan peliharaan yang diambil
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        title: const Text(
          "Pilih Hewan Peliharaan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // tampilkan pesan jika daftar hewan peliharaan kosong
            if (petList.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.pets, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "Belum ada hewan peliharaan.\nTambahkan hewan di menu Profil Hewan.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )

            // tampilkan daftar hewan peliharaan jika tidak kosong
            else
              Expanded(
                child: ListView.builder(
                  itemCount: petList.length, // jumlah item dalam daftar hewan peliharaan
                  itemBuilder: (context, index) {
                    final pet = petList[index]; // ambil data hewan peliharaan pada indeks tertentu

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.shape2.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // tampilkan informasi hewan peliharaan
                          ListTile(
                            contentPadding: EdgeInsets.zero, // hilangkan padding default
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
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PetClinicChooseServiceScreen(pet: pet), // navigasi ke layar booking dengan mengirim data hewan peliharaan
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.shape4.withOpacity(
                                  0.75,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                "Booking",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
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
