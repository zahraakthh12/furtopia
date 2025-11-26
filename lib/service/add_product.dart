import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/model/firebase/shop_firebase_model.dart';
import 'package:furtopia/view/firebase/petshop/product_dummy.dart';

class ProductSeeder {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Menambahkan seluruh dummy product ke Firestore
  static Future<void> uploadDummyProducts() async {
    final products = ProductDummyData.products;

    for (var p in products) {
      await firestore.collection("products").doc(p.uid).set({
        "uid": p.uid,
        "product": p.product,
        "category": p.category,
        "price": p.price,
        "images": p.images,
        "rating": p.rating,
        "ratingCount": p.ratingCount,
        "stock": p.stock,
        "createdAt": DateTime.now().toIso8601String(),
      });
    }

    print("=== SELESAI UPLOAD DUMMY PRODUCT ===");
  }
}
