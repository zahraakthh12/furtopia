import 'package:flutter/material.dart';
import 'package:furtopia/memory/cart_memory.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petshop/checkout_firebase_screen.dart';
import 'package:intl/intl.dart';

class CartFirebaseScreen extends StatefulWidget {
  const CartFirebaseScreen({super.key});

  @override
  State<CartFirebaseScreen> createState() => _CartFirebaseScreenState();
}

class _CartFirebaseScreenState extends State<CartFirebaseScreen> {
  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    int totalHarga = cart.fold(
      0,
      (sum, item) =>
          (sum + ((item["price"] as int) * item["quantity"])).toInt(),
    ); // harga*jumlah, dan fold() untuk menjumlahkan item dalam list

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Keranjang", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: cart.isEmpty ? emptyCartView() : cartListView(totalHarga),
    );
  }

  // VIEW: KERANJANG KOSONG
  Widget emptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Keranjang kosong!",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black.withOpacity(0.5),
            ),
          ),
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: AppColors.black.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  // VIEW: LIST PRODUK + FOOTER TOTAL
  Widget cartListView(int totalHarga) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final item = cart[index];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item["image"] != null
                        ? Image.network(
                            item["image"],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  title: Text(
                    item["product"],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    formatRupiah(item["price"]),
                    style: TextStyle(
                      color: AppColors.shape4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: Row(
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
                        },
                      ),
                      Text(
                        "${item["quantity"]}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          int stokMax = item["stock"] ?? 0;

                          if (item["quantity"] >= stokMax) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Stok tidak mencukupi"),
                                backgroundColor: AppColors.shape4,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            item["quantity"]++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // FOOTER TOTAL PRICE + CHECKOUT
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(0.15),
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    formatRupiah(totalHarga),
                    style: TextStyle(
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
                    MaterialPageRoute(
                      builder: (context) => const CheckoutFirebaseScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shape4.withOpacity(0.75),
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
