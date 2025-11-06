import 'package:flutter/material.dart';
import 'package:furtopia/memory/cart_memory.dart';
import 'package:furtopia/style/app_colors.dart';

class InvoicePage extends StatelessWidget {
  final String buyerName;
  final String phone;
  final String address;
  final String paymentMethod;
  final String shippingDistance;
  final int biayaAdmin;
  final int ongkir;
  final int totalProduk;

  const InvoicePage({
    super.key,
    required this.buyerName,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.shippingDistance,
    required this.biayaAdmin,
    required this.ongkir,
    required this.totalProduk,
  });

  @override
  Widget build(BuildContext context) {
    int grandTotal = totalProduk + biayaAdmin + ongkir;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      appBar: AppBar(
        title: const Text("Invoice"),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ringkasan Pesanan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB76E79))),
            const SizedBox(height: 14),

            buildBox([
              row("Nama", buyerName),
              row("Telepon", phone),
              row("Alamat", address),
              row("Pembayaran", paymentMethod == "cod" ? "COD" : "Transfer Bank"),
              row("Jarak", shippingDistance == "dekat" ? "Dekat" : "Jauh"),
            ]),

            const SizedBox(height: 20),

            const Text("Daftar Produk",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB76E79))),
            const SizedBox(height: 12),

            buildBox(cart.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item["product"]} x${item["quantity"]}"),
                    Text("Rp ${item["price"]}"),
                  ],
                ),
              );
            }).toList()),

            const SizedBox(height: 20),

            const Text("Biaya",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB76E79))),
            const SizedBox(height: 12),

            buildBox([
              row("Total Produk", totalProduk),
              row("Biaya Admin", biayaAdmin),
              row("Ongkir", ongkir),
              const Divider(),
              row("Grand Total", grandTotal, highlight: true),
            ]),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4.withOpacity(0.85),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderProgressPage()),
                );
              },
              child: const Text("Buat Pesanan", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBox(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget row(String left, dynamic right, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left),
          Text(
            right.toString(),
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? AppColors.shape4 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}


class OrderProgressPage extends StatelessWidget {
  const OrderProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      appBar: AppBar(
        title: const Text("Pesanan Berlangsung"),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 80, color: Color(0xFFB76E79)),
            const SizedBox(height: 20),
            const Text(
              "Pesananmu sedang diproses!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFB76E79)),
            ),
            const SizedBox(height: 10),
            const Text(
              "Kami akan menghubungi Anda jika pesanan siap.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
