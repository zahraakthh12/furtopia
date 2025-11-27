import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/view/firebase/petedu/add_edu.dart';

class PetEducationSeeder {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Upload seluruh data dummy pet education
  static Future<void> uploadDummyEducation() async {
    final edus = AddEducationFirebase.educationList;

    for (var e in edus) {
      final docRef = firestore.collection("pet_educations").doc();

      await docRef.set({
        "uid": docRef.id,
        "title": e.title,
        "image": e.image,
        "content": e.content,
        "createdAt": FieldValue.serverTimestamp(),
        "updateAt": FieldValue.serverTimestamp(),
      });
    }

    print("=== SELESAI UPLOAD DUMMY PET EDUCATION ===");
  }
}
