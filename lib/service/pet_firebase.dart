import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';

class PetFirebaseService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const String collection = "pets";

  /// CREATE PET
  static Future<PetFirebaseModel> createPet(PetFirebaseModel pet) async {
    final doc = firestore.collection(collection).doc();

    final newPet = PetFirebaseModel(
      uid: doc.id,
      ownerId: pet.ownerId,
      name: pet.name,
      type: pet.type,
      gender: pet.gender,
      age: pet.age,
      color: pet.color,
      weight: pet.weight,
      length: pet.length,
      icon: pet.icon,
      createdAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );

    await doc.set(newPet.toMap());
    return newPet;
  }

  /// GET ALL PETS
  static Future<List<PetFirebaseModel>> getAllPets() async {
    final snap = await firestore.collection(collection).get();

    return snap.docs
        .map((e) => PetFirebaseModel.fromMap({"uid": e.id, ...e.data()}))
        .toList();
  }

  /// GET PET BY ID
  static Future<PetFirebaseModel?> getPet(String uid) async {
    final doc = await firestore.collection(collection).doc(uid).get();
    if (!doc.exists) return null;

    return PetFirebaseModel.fromMap({"uid": doc.id, ...doc.data()!});
  }

  /// GET PETS BY OWNER ID
  static Future<List<PetFirebaseModel>> getPetsByOwner(String ownerId) async {
    final snap = await firestore
        .collection(collection)
        .where("ownerId", isEqualTo: ownerId)
        .get();

    return snap.docs.map((doc) {
      return PetFirebaseModel.fromMap({"uid": doc.id, ...doc.data()});
    }).toList();
  }

  /// UPDATE PET
  static Future<void> updatePet(PetFirebaseModel pet) async {
    if (pet.uid == null) {
      throw Exception("Pet uid tidak ditemukan");
    }

    final updatedData = PetFirebaseModel(
      uid: pet.uid,
      ownerId: pet.ownerId,
      name: pet.name,
      type: pet.type,
      gender: pet.gender,
      age: pet.age,
      color: pet.color,
      weight: pet.weight,
      length: pet.length,
      icon: pet.icon,
      createdAt: pet.createdAt,
      updateAt: DateTime.now().toIso8601String(),
    );

    await firestore
        .collection(collection)
        .doc(pet.uid)
        .update(updatedData.toMap());
  }

  /// DELETE PET
  static Future<void> deletePet(String uid) async {
    await firestore.collection(collection).doc(uid).delete();
  }
}
