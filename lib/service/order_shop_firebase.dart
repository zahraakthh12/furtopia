import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseOrderService {
  static final firestore = FirebaseFirestore.instance;

  /// Generate Invoice: INV-YYYYMMDD-0001
  static Future<String> generateInvoice() async {
    final String today = DateFormat("yyyyMMdd").format(DateTime.now());
    final String prefix = "INV-$today";

    final snapshot = await firestore
        .collection("orders")
        .where("invoice", isGreaterThanOrEqualTo: prefix)
        .where("invoice", isLessThan: "$prefix~")
        .orderBy("invoice", descending: true)
        .limit(1)
        .get();

    int nextNumber = 1;

    if (snapshot.docs.isNotEmpty) {
      final String lastInvoice = snapshot.docs.first["invoice"];
      final String lastNumber = lastInvoice.split("-").last;
      nextNumber = int.tryParse(lastNumber)! + 1;
    }

    return "$prefix-${nextNumber.toString().padLeft(4, '0')}";
  }

  /// SIMPAN PESANAN + RETURN invoice & orderId
  static Future<Map<String, dynamic>> saveOrder({
    required String userId,
    required List<Map<String, dynamic>> products,
    required int subtotal,
    required int adminFee,
    required int total,
  }) async {
    final docRef = firestore.collection("orders").doc();
    final orderId = docRef.id;

    final invoice = await generateInvoice();

    await docRef.set({
      "invoice": invoice,
      "userId": userId,
      "products": products,
      "subtotal": subtotal,
      "adminFee": adminFee,
      "total": total,
      "status": "pending",
      "createdAt": DateTime.now().toIso8601String(),
    });

    return {
      "invoice": invoice,
      "orderId": orderId,
    };
  }
}
