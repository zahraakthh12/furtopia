import 'package:flutter/material.dart';
import 'package:furtopia/memory/cart_memory.dart';
import 'package:furtopia/service/order_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/profil_user/ongoing_firebase_order.dart';
import 'package:intl/intl.dart';
import 'package:furtopia/preferences/preference_handler.dart';

class CheckoutFirebaseScreen extends StatefulWidget {
  const CheckoutFirebaseScreen({super.key});

  @override
  State<CheckoutFirebaseScreen> createState() => _CheckoutFirebaseScreenState();
}

class _CheckoutFirebaseScreenState extends State<CheckoutFirebaseScreen> {
  final int adminFee = 5000;

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    int subtotal = cart.fold<int>(
      0,
      (sum, item) => sum + ((item["price"] as int) * (item["quantity"] as int)),
    );

    int totalBayar = subtotal + adminFee;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 12),

                // =======================
                // LIST PRODUK
                // =======================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Daftar Pesanan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                ...cart.map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item["image"],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // DETAIL PRODUK
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["product"],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${item["quantity"]} x ${formatRupiah(item["price"])}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          formatRupiah(item["price"] * item["quantity"]),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.shape4,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),

                // =======================
                // RINGKASAN PEMBAYARAN
                // =======================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Ringkasan Pembayaran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                summaryRow("Subtotal", formatRupiah(subtotal)),
                summaryRow("Biaya Admin", formatRupiah(adminFee)),
                summaryRow(
                  "Total Bayar",
                  formatRupiah(totalBayar),
                  bold: true,
                  color: AppColors.shape4,
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),

          // =======================
          // BUTTON BUAT PESANAN
          // =======================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                String? userId = await PreferenceHandler.getToken();

                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User tidak ditemukan")),
                  );
                  return;
                }

                // Siapkan list item yang akan disimpan
                List<Map<String, dynamic>> orderProducts = cart.map((item) {
                  return {
                    "product": item["product"],
                    "price": item["price"],
                    "quantity": item["quantity"],
                    "image": item["image"],
                    "subtotal": item["price"] * item["quantity"],
                  };
                }).toList();

                await FirebaseOrderService.saveOrder(
                  userId: userId,
                  products: orderProducts,
                  subtotal: subtotal,
                  adminFee: adminFee,
                  total: totalBayar,
                );

                cart.clear();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text("Pesanan Berhasil!"),
                    content: Text(
                      "Invoice berhasil dibuat dan pesanan disimpan.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // tutup dialog

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderInProgressScreen(),
                            ),
                          );
                        },

                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4.withOpacity(0.85),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Buat Pesanan",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // RINGKASAN ROW
  Widget summaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
