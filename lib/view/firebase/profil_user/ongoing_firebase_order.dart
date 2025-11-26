import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petshop/order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrderInProgressScreen extends StatelessWidget {
  OrderInProgressScreen({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Harap login terlebih dahulu.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pesanan Berlangsung",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("orders")
            .where("userId", isEqualTo: user.uid)
            .where("status", whereIn: ["pending", "process", "on-delivery"])
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Tidak ada pesanan berlangsung",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;

              final items = List<Map<String, dynamic>>.from(data["products"]);
              final status = data["status"];
              final total = data["total"];
              final invoice = data["invoice"];

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Invoice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Invoice: $invoice",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor(status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(maxWidth: 120),
                          child: Text(
                            statusLabel(status),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Item pertama
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            items[0]["image"],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            items[0]["product"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Jika item > 1
                    if (items.length > 1)
                      Text(
                        "+${items.length - 1} produk lainnya",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),

                    SizedBox(height: 12),

                    // Total bayar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Bayar:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formatRupiah(total),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.shape4,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailScreen(orderId: orders[index].id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.shape4.withOpacity(0.85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Lihat Detail",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Warna label status
  Color statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "process":
        return Colors.blue;
      case "on-delivery":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Label status untuk UI
  String statusLabel(String status) {
    switch (status) {
      case "pending":
        return "Menunggu Diproses";
      case "process":
        return "Diproses";
      case "on-delivery":
        return "Dikirim";
      default:
        return "Unknown";
    }
  }
}
