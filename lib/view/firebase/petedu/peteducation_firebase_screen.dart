import 'package:cloud_firestore/cloud_firestore.dart';
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
              MaterialPageRoute(builder: (_) => BottomNavFirebase()),
            );
          },
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pet_educations")
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada artikel edukasi."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final model = PetEducationModel.fromMap(
                data.data() as Map<String, dynamic>,
                data.id,
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PetEduDetailScreen(education: model),
                    ),
                  );
                },
                child: _buildEduCard(model),
              );
            },
          );
        },
      ),
    );
  }

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
                  : "",
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) =>
                  const Icon(Icons.broken_image, size: 60, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              model.title ?? "",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
