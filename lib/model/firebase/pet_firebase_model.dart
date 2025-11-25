import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PetFirebaseModel {
  String? uid;
  String? ownerId;
  String? name;
  String? type;
  String? gender;
  String? age;
  String? color;
  String? weight;
  String? length;
  String? icon;
  String? createdAt;
  String? updateAt;
  PetFirebaseModel({
    this.uid,
    this.ownerId,
    this.name,
    this.type,
    this.gender,
    this.age,
    this.color,
    this.weight,
    this.length,
    this.icon,
    this.createdAt,
    this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'ownerId': ownerId,
      'type': type,
      'gender': gender,
      'age': age,
      'color': color,
      'weight': weight,
      'length': length,
      'icon': icon,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }

  factory PetFirebaseModel.fromMap(Map<String, dynamic> map) {
    return PetFirebaseModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      age: map['age'] != null ? map['age'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      weight: map['weight'] != null ? map['weight'] as String : null,
      length: map['length'] != null ? map['length'] as String : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updateAt: map['updateAt'] != null ? map['updateAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetFirebaseModel.fromJson(String source) =>
      PetFirebaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
