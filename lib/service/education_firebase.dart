import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/model/firebase/education_firebase_model.dart';

class EducationFirebaseService {
  static final _ref = FirebaseFirestore.instance.collection("pet_educations");

  // CREATE
  static Future<void> addEducation(PetEducationModel model) async {
    final docRef = _ref.doc();
    await docRef.set(model.toMap());
  }

  // LIST
  static Stream<List<PetEducationModel>> getEducationList() {
    return _ref
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PetEducationModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // DETAIL
  static Future<PetEducationModel?> getDetail(String id) async {
    final doc = await _ref.doc(id).get();
    if (!doc.exists) return null;
    return PetEducationModel.fromMap(doc.data()!, doc.id);
  }
}
