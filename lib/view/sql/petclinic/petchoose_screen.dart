import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/pet_model.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/sql/petclinic/petclinic_booking.dart';

class PetChooseScreen extends StatefulWidget {
  const PetChooseScreen({super.key});

  @override
  State<PetChooseScreen> createState() => _PetChooseScreenState();
}

class _PetChooseScreenState extends State<PetChooseScreen> {
  List<PetModel> petList = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        title: Text(
          "Pilih Hewan Peliharaan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
                      "Belum ada hewan peliharaan, kamu perlu menambahkan di halaman Pet",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
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
                              pet.icon,
                              style: const TextStyle(fontSize: 40),
                            ),
                            title: Text(
                              pet.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "${pet.type} • ${pet.age}",
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Tombol Booking
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingScreen(
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.shape4.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: Text(
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
