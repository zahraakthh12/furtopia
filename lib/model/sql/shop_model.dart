import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShopModel {
  int? id;
  String product;
  String category;
  String price;
  String image;
  ShopModel({
    this.id,
    required this.product,
    required this.category,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product,
      'category': category,
      'price': price,
      'image': image,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] as int,
      product: map['product'] as String,
      category: map['category'] as String,
      price: map['price'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source) as Map<String, dynamic>);
}