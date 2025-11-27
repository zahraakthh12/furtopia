import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClinicFirebaseModel {
  String? uid;
  String? product;
  String? description;
  String? price;
  String? schedule;
  String? category;
  String? createdAt;
  String? updateAt;
  ClinicFirebaseModel({
    this.uid,
    this.product,
    this.description,
    this.price,
    this.schedule,
    this.category,
    this.createdAt,
    this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'product': product,
      'description': description,
      'price': price,
      'schedule': schedule,
      'category': category,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }

  factory ClinicFirebaseModel.fromMap(Map<String, dynamic> map) {
    return ClinicFirebaseModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      product: map['product'] != null ? map['product'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      schedule: map['schedule'] != null ? map['schedule'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updateAt: map['updateAt'] != null ? map['updateAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClinicFirebaseModel.fromJson(String source) => ClinicFirebaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
