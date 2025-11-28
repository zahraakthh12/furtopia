import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/model/firebase/clinic_firebase_model.dart';

class ClinicServiceFirebase {
  static final _firestore = FirebaseFirestore.instance;
  static const collection = "clinic_services";

  // GET ALL CLINIC SERVICES
  static Future<List<ClinicFirebaseModel>> getAllServices() async {
    final snap = await _firestore.collection(collection).get();

    return snap.docs.map((doc) {
      return ClinicFirebaseModel.fromMap({
        "uid": doc.id,
        ...doc.data(),
      });
    }).toList();
  }

  // FILTER BY CATEGORY
  static Future<List<ClinicFirebaseModel>> getServicesByCategory(String category) async {
    if (category == "all") {
      return getAllServices();
    }

    final snap = await _firestore
        .collection(collection)
        .where("category", isEqualTo: category)
        .get();

    return snap.docs.map((doc) {
      return ClinicFirebaseModel.fromMap({
        "uid": doc.id,
        ...doc.data(),
      });
    }).toList();
  }
}
