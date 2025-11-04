// import 'dart:convert';

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class CartModel {
//   int? id;
//   String product;
//   String quantity;
//   String price;
//   String image;
//   CartModel({
//     this.id,
//     required this.product,
//     required this.quantity,
//     required this.price,
//     required this.image,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'product': product,
//       'quantity': quantity,
//       'price': price,
//       'image': image,
//     };
//   }

//   factory CartModel.fromMap(Map<String, dynamic> map) {
//     return CartModel(
//       id: map['id'] as int,
//       product: map['product'] as String,
//       quantity: map['quantity'] as String,
//       price: map['price'] as String,
//       image: map['image'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory CartModel.fromJson(String source) =>
//       CartModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }