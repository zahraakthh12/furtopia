import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/model/firebase/shop_firebase_model.dart';

class ShopFirebaseService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const String collection = "shop_items";

  /// CREATE PRODUCT
  static Future<ShopFirebaseModel> createProduct(ShopFirebaseModel product) async {
    final doc = firestore.collection(collection).doc();

    final newProduct = ShopFirebaseModel(
      uid: doc.id,
      ownerId: product.ownerId,
      product: product.product,
      category: product.category,
      price: product.price,
      images: product.images,
      rating: product.rating ?? 0.0,
      ratingCount: product.ratingCount ?? 0,
      stock: product.stock,
      createdAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );

    await doc.set(newProduct.toMap());
    return newProduct;
  }

  /// GET ALL PRODUCTS
  static Future<List<ShopFirebaseModel>> getAllProducts() async {
    final snap = await firestore.collection(collection).get();

    return snap.docs
        .map((e) => ShopFirebaseModel.fromMap({
              "uid": e.id,
              ...e.data(),
            }))
        .toList();
  }

  /// GET PRODUCTS BY OWNER
  static Future<List<ShopFirebaseModel>> getProductsByOwner(String ownerId) async {
    final snap = await firestore
        .collection(collection)
        .where("ownerId", isEqualTo: ownerId)
        .get();

    return snap.docs.map((e) => ShopFirebaseModel.fromMap({
          "uid": e.id,
          ...e.data(),
        })).toList();
  }

  /// GET PRODUCTS BY CATEGORY
  static Future<List<ShopFirebaseModel>> getProductsByCategory(String category) async {
    final snap = await firestore
        .collection(collection)
        .where("category", isEqualTo: category)
        .get();

    return snap.docs.map((e) => ShopFirebaseModel.fromMap({
          "uid": e.id,
          ...e.data(),
        })).toList();
  }

  /// GET PRODUCT BY UID
  static Future<ShopFirebaseModel?> getProduct(String uid) async {
    final doc = await firestore.collection(collection).doc(uid).get();
    if (!doc.exists) return null;

    return ShopFirebaseModel.fromMap({
      "uid": doc.id,
      ...doc.data()!,
    });
  }

  /// UPDATE PRODUCT
  static Future<void> updateProduct(ShopFirebaseModel product) async {
    if (product.uid == null) {
      throw Exception("UID product tidak ditemukan");
    }

    final updated = ShopFirebaseModel(
      uid: product.uid,
      ownerId: product.ownerId,
      product: product.product,
      category: product.category,
      price: product.price,
      images: product.images,
      rating: product.rating,
      ratingCount: product.ratingCount,
      stock: product.stock,
      createdAt: product.createdAt,
      updateAt: DateTime.now().toIso8601String(),
    );

    await firestore
        .collection(collection)
        .doc(product.uid)
        .update(updated.toMap());
  }

  /// DELETE PRODUCT
  static Future<void> deleteProduct(String uid) async {
    await firestore.collection(collection).doc(uid).delete();
  }

  /// SEARCH PRODUCT by keyword
  static Future<List<ShopFirebaseModel>> searchProduct(String query) async {
    final snap = await firestore
        .collection(collection)
        .where("product", isGreaterThanOrEqualTo: query)
        .where("product", isLessThanOrEqualTo: "$query\uf8ff")
        .get();

    return snap.docs.map((e) => ShopFirebaseModel.fromMap({
          "uid": e.id,
          ...e.data(),
        })).toList();
  }
}
