import 'package:flutter/material.dart';
import 'package:furtopia/memory/cart_memory.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/petshop/checkout_screen.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final customFont = "Poppins";

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  } // Mengubah ke format rupiah

  @override
  Widget build(BuildContext context) {
    int totalHarga = cart.fold(
      0, (sum, item) => (sum + ((item["price"] as int) * item["quantity"])).toInt(),); // harga*jumlah, dan fold() untuk menjumlahkan item dalam list

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text(
          "Keranjang",
          style: TextStyle(
            fontFamily: customFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      // Jika keranjang kosong
      body: cart.isEmpty
          ? Center(
              child: Text(
                "Keranjang kosong",
                style: TextStyle(
                  fontFamily: customFont,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                // List Produk
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];

                      return Card(
                        color: AppColors.white,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item["image"],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item["product"],
                            style: TextStyle(
                                fontFamily: customFont,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            formatRupiah(item["price"]),
                            style: TextStyle(
                              fontFamily: customFont,
                              color: AppColors.shape4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Tambah / Kurangi / Hapus
                          trailing: Column(
                            children: [
                              // row + -
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (item["quantity"] > 1) {
                                            item["quantity"]--;
                                          } else {
                                            cart.removeAt(index);
                                          }
                                        });
                                      }),
                                  Text(
                                    "${item["quantity"]}",
                                    style: TextStyle(
                                        fontFamily: customFont,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          item["quantity"]++;
                                        });
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bagian Total & Checkout
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.15),
                          offset: Offset(0, -2))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total:",
                              style: TextStyle(
                                  fontFamily: customFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(
                            formatRupiah(totalHarga),
                            style: TextStyle(
                              fontFamily: customFont,
                              color: AppColors.shape4,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CheckoutScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.shape4.withOpacity(0.75),
                          minimumSize: Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              fontFamily: customFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
