import 'package:cloud_firestore/cloud_firestore.dart';

class PetEducationModel {
  String? id;
  String? title;
  List<String>? image;
  String? content;
  Timestamp? createdAt;


  PetEducationModel({
    this.id,
    this.title,
    this.image,
    this.content,
    this.createdAt,
  });

  factory PetEducationModel.fromMap(Map<String, dynamic> map, String id) {
    return PetEducationModel(
      id: id,
      title: map['title'],
      image: map['image'] != null ? List<String>.from(map['image']) : [],
      content: map['content'],
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "image": image,
      "content": content,
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
