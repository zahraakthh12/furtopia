import 'dart:convert';

class OrderFirebaseModel {
  String? orderId;
  String? invoiceCode; 
  String? userId; 
  List<Map<String, dynamic>> items; 
  int subtotal; 
  int adminFee; 
  int total; 
  String? createdAt;
  String status;

  OrderFirebaseModel({
    this.orderId,
    this.invoiceCode,
    this.userId,
    required this.items,
    required this.subtotal,
    required this.adminFee,
    required this.total,
    this.createdAt,
    this.status = "pending",
  });

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "invoiceCode": invoiceCode,
      "userId": userId,
      "items": items,
      "subtotal": subtotal,
      "adminFee": adminFee,
      "total": total,
      "createdAt": createdAt,
      "status": status,
    };
  }

  factory OrderFirebaseModel.fromMap(Map<String, dynamic> map) {
    return OrderFirebaseModel(
      orderId: map["orderId"],
      invoiceCode: map["invoiceCode"],
      userId: map["userId"],
      items: List<Map<String, dynamic>>.from(map["items"] ?? []),
      subtotal: map["subtotal"] ?? 0,
      adminFee: map["adminFee"] ?? 0,
      total: map["total"] ?? 0,
      createdAt: map["createdAt"],
      status: map["status"] ?? "pending",
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderFirebaseModel.fromJson(String source) =>
      OrderFirebaseModel.fromMap(json.decode(source));
}
