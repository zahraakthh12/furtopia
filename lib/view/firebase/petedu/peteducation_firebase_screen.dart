import 'package:cloud_firestore/cloud_firestore.dart'; // menambahkan import untuk Firestore
import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/education_firebase_model.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/navigation/bottom_nav_firebase.dart';
import 'package:furtopia/view/firebase/petedu/petedu_detail_screen.dart';

class EduFirebaseScreen extends StatelessWidget {
  const EduFirebaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        title: const Text(
          "Pet Education",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BottomNavFirebase()), // Kembali ke BottomNavFirebase
            );
          },
        ),
      ),

      body: 
      //  menggunakan stream builder untuk mengambil data edukasi dari Firestore secara real-time
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pet_educations")
            .orderBy("createdAt", descending: true)
            .snapshots(),

        // membangun UI berdasarkan snapshot data dari Firestore
        builder: (context, snapshot) {

          // menampilkan indikator loading saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // menampilkan pesan jika tidak ada data edukasi
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada artikel edukasi."));
          }

          // menampilkan daftar edukasi hewan peliharaan
          final docs = snapshot.data!.docs;

          // menggunakan ListView.builder untuk menampilkan daftar edukasi
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length, // jumlah item berdasarkan data dari Firestore
            itemBuilder: (context, index) {
              final data = docs[index]; // data edukasi pada indeks saat ini
              final model = PetEducationModel.fromMap(
                data.data() as Map<String, dynamic>, // konversi data ke dalam model
                data.id, // menggunakan ID dokumen sebagai id model
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PetEduDetailScreen(education: model), // navigasi ke detail edukasi dengan mengirim data model
                    ),
                  );
                },
                child: _buildEduCard(model), // membangun kartu edukasi
              );
            },
          );
        },
      ),
    );
  }

  // Widget untuk membangun kartu edukasi hewan peliharaan
  Widget _buildEduCard(PetEducationModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.shape4.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              model.image != null && model.image!.isNotEmpty
                  ? model.image!.first
                  : "", // jika tidak ada gambar, tampilkan string kosong
              height: 100,
              width: 100,
              fit: BoxFit.cover, // menyesuaikan gambar agar memenuhi area
              errorBuilder: (context, error, stack) => // menampilkan ikon jika gambar gagal dimuat
                  const Icon(Icons.broken_image, size: 60, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              model.title ?? "",
              maxLines: 3, // batasi hingga 3 baris
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
