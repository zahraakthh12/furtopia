import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShopFirebaseModel {
  String? uid;
  String? ownerId;
  String? product;
  String? category;
  String? price;
  List<String>? images;
  double? rating;
  int? ratingCount;
  String? stock;
  String? createdAt;
  String? updateAt;

  ShopFirebaseModel({
    this.uid,
    this.ownerId,
    this.product,
    this.category,
    this.price,
    this.images,
    this.rating,
    this.ratingCount,
    this.stock,
    this.createdAt,
    this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'ownerId': ownerId,
      'product': product,
      'category': category,
      'price': price,
      'images': images,
      'rating': rating,
      'ratingCount': ratingCount,
      'stock': stock,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }

  factory ShopFirebaseModel.fromMap(Map<String, dynamic> map) {
    return ShopFirebaseModel(
      uid: map['uid'],
      ownerId: map['ownerId'],
      product: map['product'],
      category: map['category'],
      price: map['price'],
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : 0.0,
      ratingCount: map['ratingCount'] ?? 0,
      stock: map['stock'],
      createdAt: map['createdAt'],
      updateAt: map['updateAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopFirebaseModel.fromJson(String source) =>
      ShopFirebaseModel.fromMap(json.decode(source));
}
