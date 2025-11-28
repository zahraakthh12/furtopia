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
  List<PetFirebaseModel> petList = [];

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  /// GET PET LIST FROM FIREBASE
  Future<void> fetchPets() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final pets = await PetFirebaseService.getPetsByOwner(uid);

    setState(() {
      petList = pets;
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
            else
              Expanded(
                child: ListView.builder(
                  itemCount: petList.length,
                  itemBuilder: (context, index) {
                    final pet = petList[index];

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
                          ListTile(
                            contentPadding: EdgeInsets.zero,
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
                                        PetClinicChooseServiceScreen(pet: pet),
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
