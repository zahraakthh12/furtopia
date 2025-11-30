import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furtopia/model/firebase/user_firebase_model.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String collection = "users";

  /// REGISTER USER (FirebaseAuth + Firestore)
  static Future<UserFirebaseModel> registerUser({
  required String fullname,
  required String email,
  required String phone,
  required String password,
}) async {
  final cred = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  final user = cred.user!;
  final uid = user.uid;

  final model = UserFirebaseModel(
    uid: uid,
    fullname: fullname,
    email: email,
    phone: phone,
    address: "", // alamat awal kosong
    createdAt: DateTime.now().toIso8601String(),
    updateAt: DateTime.now().toIso8601String(),
  );

  await firestore.collection(collection).doc(uid).set(model.toMap());

  return model;
}


  /// LOGIN USER (FirebaseAuth + Firestore)
  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) return null;

      // Get user from Firestore
      final doc = await firestore.collection(collection).doc(user.uid).get();
      if (!doc.exists) return null; // user tidak ditemukan di Firestore

      return UserFirebaseModel.fromMap({
        "uid": user.uid, // pastikan uid disertakan
        ...doc.data()!, // gabungkan data dari Firestore
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return null;
      } // jika kredensial salah atau user tidak ditemukan
      print("FirebaseAuth Error: ${e.code}");
      rethrow;
    }
  }

  /// GET USER BY UID
  static Future<UserFirebaseModel?> getUser(String uid) async {
    final doc = await firestore.collection(collection).doc(uid).get();
    if (!doc.exists) return null;

    return UserFirebaseModel.fromMap({
      "uid": doc.id,
      ...doc.data()!,
    });
  }

  /// GET ALL USERS
  static Future<List<UserFirebaseModel>> getAllUsers() async {
    final snap = await firestore.collection(collection).get();

    return snap.docs
        .map((doc) => UserFirebaseModel.fromMap({
              "uid": doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  /// UPDATE USER
  static Future<void> updateUser(UserFirebaseModel user) async {
    if (user.uid == null) {
      throw Exception("UID user tidak ditemukan!");
    }

    final updated = UserFirebaseModel(
      uid: user.uid,
      fullname: user.fullname,
      email: user.email,
      phone: user.phone,
      address: user.address,
      createdAt: user.createdAt,
      updateAt: DateTime.now().toIso8601String(),
    );

    await firestore
        .collection(collection)
        .doc(user.uid)
        .update(updated.toMap());
  }

  /// DELETE USER
  static Future<void> deleteUser(String uid) async {
    await firestore.collection(collection).doc(uid).delete();
  }
}
