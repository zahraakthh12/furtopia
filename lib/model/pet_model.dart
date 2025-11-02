import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PetModel {
  int? id;
  String name;
  String type;
  String gender;
  String age;
  String color;
  String weight;
  String length;
  String icon;
  PetModel({
    this.id,
    required this.name,
    required this.type,
    required this.gender,
    required this.age,
    required this.color,
    required this.weight,
    required this.length,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'gender': gender,
      'age': age,
      'color': color,
      'weight': weight,
      'length': length,
      'icon': icon,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      gender: map['gender'] as String,
      age: map['age'] as String,
      color: map['color'] as String,
      weight: map['weight'] as String,
      length: map['length'] as String,
      icon: map['icon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}