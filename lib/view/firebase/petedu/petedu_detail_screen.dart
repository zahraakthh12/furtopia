import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/education_firebase_model.dart';
import 'package:furtopia/style/app_colors.dart';

class PetEduDetailScreen extends StatelessWidget {
  final PetEducationModel education;

  const PetEduDetailScreen({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          education.title ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                education.image != null && education.image!.isNotEmpty
                    ? education.image!.first
                    : "",
                height: 200,
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.broken_image, size: 120, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              education.title ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Text(
              education.content ?? "",
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "❤️ Rawat hewanmu dengan kasih sayang di FurTopia ❤️",
                style: TextStyle(
                  color: AppColors.text1.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
