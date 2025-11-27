import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  String rupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final products = List<Map<String, dynamic>>.from(data["products"]);
          final invoice = data["invoice"];
          final subtotal = data["subtotal"];
          final adminFee = data["adminFee"];
          final total = data["total"];
          final status = data["status"];
          final createdAt = data["createdAt"];

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              // ===================== INVOICE BOX =====================
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "No. Pesanan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(invoice, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                      "Tanggal Pesanan:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(createdAt.toString()),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // ===================== PRODUK LIST =====================
              Text(
                "Produk",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              ...products.map((p) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          p["image"],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p["product"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text("${p["quantity"]} x ${rupiah(p["price"])}"),
                          ],
                        ),
                      ),
                      Text(
                        rupiah(p["subtotal"]),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),

              SizedBox(height: 16),

              // ===================== RINGKASAN =====================
              Text(
                "Ringkasan Pembayaran",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              summaryRow("Subtotal", rupiah(subtotal)),
              summaryRow("Biaya Admin", rupiah(adminFee)),
              summaryRow(
                "Total Bayar",
                rupiah(total),
                bold: true,
                color: AppColors.shape4,
              ),

              SizedBox(height: 30),

              // ===================== TOMBOL AKSI =====================
              if (status == "pending") ...[
                actionButton(
                  text: "Batalkan Pesanan",
                  color: Colors.red,
                  onTap: () => cancelOrder(context),
                ),
                SizedBox(height: 12),
              ],

              if (status == "on-delivery") ...[
                actionButton(
                  text: "Pesanan Diterima",
                  color: Colors.green,
                  onTap: () => completeOrder(context),
                ),
              ],

              if (status == "process")
                Center(
                  child: Text(
                    "Pesanan sedang diproses...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

              SizedBox(height: 20),

              Container(
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
                    Text(
                      "Hubungi Kami",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Jika Anda butuh bantuan, silakan hubungi admin melalui WhatsApp.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        contactAdmin(data);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.shape4.withOpacity(0.85),
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.chat_bubble, color: Colors.white),
                      label: Text(
                        "Chat Admin di WhatsApp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =========================== FUNGSI TAMBAHAN ===========================

  Widget summaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // =========================== AKSI BUTTON ===========================

  void cancelOrder(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Batalkan Pesanan?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Apakah Anda yakin ingin membatalkan pesanan ini?\nTindakan ini tidak dapat dibatalkan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Tidak"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ya, Batalkan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "cancel",
      "updatedAt": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pesanan berhasil dibatalkan"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void completeOrder(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Pesanan Diterima?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Pastikan barang sudah diterima dengan baik."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Belum"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Sudah Diterima",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "done",
      "updatedAt": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pesanan telah selesai"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void contactAdmin(Map<String, dynamic> order) async {
    final adminNumber = "085710546602";

    final invoice = order["invoice"];
    final total = order["total"];
    final createdAt = order["createdAt"]?.toString() ?? "";
    final products = List<Map<String, dynamic>>.from(order["products"]);

    // Buat format produk
    String productList = products
        .map((p) {
          return "- ${p["product"]} (${p["quantity"]} x Rp${p["price"]})";
        })
        .join("\n");

    final message =
        """
Halo Admin 👋

Saya ingin menanyakan pesanan saya.

➡️ *No. Pesanan:* $invoice
➡️ *Tanggal:* $createdAt

*Daftar Produk:*
$productList

*Total Pembayaran:* Rp$total

Mohon bantuannya ya 🙏
""";

    final url = Uri.parse(
      "https://wa.me/62${adminNumber.substring(1)}?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
