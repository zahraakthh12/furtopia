import 'package:flutter/material.dart';
import 'package:furtopia/memory/cart_memory.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/petshop/order_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final customFont = "Poppins";

  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController addressC = TextEditingController();

  String paymentMethod = "cod";
  String shippingDistance = "dekat"; // dekat / jauh

  final int biayaAdmin = 5000;

  int hitungOngkir() {
    return shippingDistance == "dekat" ? 10000 : 20000;
  }

  int hitungTotalProduk() {
    return cart.fold<int>(0, (sum, item) =>
      sum + (item["price"] as int) * (item["quantity"] as int));
  }

  @override
  Widget build(BuildContext context) {
    int ongkir = hitungOngkir();
    int totalProduk = hitungTotalProduk();
    int grandTotal = totalProduk + biayaAdmin + ongkir;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      appBar: AppBar(
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        title: Text("Checkout",
            style: TextStyle(fontFamily: customFont, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Data Pembeli",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB76E79))),

            const SizedBox(height: 12),
            buildInput("Nama Lengkap", nameC),
            buildInput("Nomor Telepon", phoneC, keyboardType: TextInputType.phone),
            buildInput("Alamat Lengkap", addressC, maxLines: 3),

            const SizedBox(height: 20),

            const Text("Metode Pembayaran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB76E79))),

            RadioListTile(
              title: const Text("Bayar di Tempat (COD)"),
              value: "cod",
              activeColor: AppColors.shape4,
              groupValue: paymentMethod,
              onChanged: (v) => setState(() => paymentMethod = v.toString()),
            ),
            RadioListTile(
              title: const Text("Transfer Bank"),
              value: "transfer",
              activeColor: AppColors.shape4,
              groupValue: paymentMethod,
              onChanged: (v) => setState(() => paymentMethod = v.toString()),
            ),

            const SizedBox(height: 20),

            const Text("Jarak Pengiriman",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB76E79))),

            RadioListTile(
              title: const Text("Dekat (Rp 10.000)"),
              value: "dekat",
              activeColor: AppColors.shape4,
              groupValue: shippingDistance,
              onChanged: (v) => setState(() => shippingDistance = v.toString()),
            ),
            RadioListTile(
              title: const Text("Jauh (Rp 20.000)"),
              value: "jauh",
              activeColor: AppColors.shape4,
              groupValue: shippingDistance,
              onChanged: (v) => setState(() => shippingDistance = v.toString()),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  summaryRow("Total Produk", totalProduk),
                  summaryRow("Biaya Admin", biayaAdmin),
                  summaryRow("Biaya Ongkir", ongkir),
                  const Divider(),
                  summaryRow("Grand Total", grandTotal, highlight: true),
                ],
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4.withOpacity(0.85),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                if (nameC.text.isEmpty || phoneC.text.isEmpty || addressC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mohon isi semua data")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InvoicePage(
                      buyerName: nameC.text,
                      phone: phoneC.text,
                      address: addressC.text,
                      paymentMethod: paymentMethod,
                      shippingDistance: shippingDistance,
                      biayaAdmin: biayaAdmin,
                      ongkir: ongkir,
                      totalProduk: totalProduk,
                    ),
                  ),
                );
              },
              child: const Text("Lanjut ke Invoice", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(String title, int value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.normal)),
          Text(
            "Rp ${value.toString()}",
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? AppColors.shape4 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput(String label, TextEditingController c,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFFB76E79))),
          const SizedBox(height: 6),
          TextField(
            controller: c,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFB76E79), width: 0.3)),
            ),
          ),
        ],
      ),
    );
  }
}
