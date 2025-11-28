import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/view/firebase/petclinic/add_product_clinic.dart';

class ClinicProductSeeder {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Upload seluruh data dummy clinic
  static Future<void> uploadDummyClinicServices() async {
    final products = AddProductClinic.productsClinic;

    for (var p in products) {
      // generate dokumen baru setiap produk
      final docRef = firestore.collection("clinic_services").doc();

      await docRef.set({
        "uid": p.uid,
        "product": p.product,
        "description": p.description,
        "price": p.price,
        "category": p.category,
        "createdAt": DateTime.now().toIso8601String(),
        "updateAt": DateTime.now().toIso8601String(),
      });
    }

    print("=== SELESAI UPLOAD DUMMY CLINIC SERVICES ===");
  }
}
