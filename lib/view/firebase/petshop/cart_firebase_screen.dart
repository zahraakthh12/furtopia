import 'package:flutter/material.dart';
import 'package:furtopia/memory/cart_memory.dart';
import 'package:furtopia/model/firebase/shop_firebase_model.dart';
import 'package:furtopia/service/shop_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/firebase/petshop/checkout_firebase_screen.dart';
import 'package:intl/intl.dart';

class CartFirebaseScreen extends StatefulWidget {
  const CartFirebaseScreen({super.key});

  @override
  State<CartFirebaseScreen> createState() => _CartFirebaseScreenState();
}

class _CartFirebaseScreenState extends State<CartFirebaseScreen> {
  bool loading = true;
  Map<String, ShopFirebaseModel?> productData = {};

  @override
  void initState() {
    super.initState();
    loadProductsFromFirebase();
  }

  /// Ambil ulang semua data dari Firebase berdasarkan UID yg ada di cart
  Future<void> loadProductsFromFirebase() async {
    loading = true;
    setState(() {});

    productData.clear();

    for (var item in cart) {
      final uid = item["uid"];

      // jika uid kosong atau null → skip saja
      if (uid == null || uid.toString().isEmpty) continue;

      final product = await ShopFirebaseService.getProduct(uid);
      productData[uid] = product;
    }

    loading = false;
    setState(() {});
  }

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Keranjang",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.shape4.withOpacity(0.75),
        ),
        body: emptyCartView(),
      );
    }

    int totalHarga = 0;

    for (var item in cart) {
      final data = productData[item["uid"]];

      if (data != null) {
        final price = int.tryParse(data.price ?? "0") ?? 0;
        final qty = int.tryParse(item["quantity"].toString()) ?? 1;

        totalHarga += price * qty;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Keranjang",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),
      body: Stack(
        children: [
          buildBackground(), // background muncul
          Container(
            color: Colors.white.withOpacity(0), // <= buat transparan
            child: cartListView(totalHarga),
          ),
        ],
      ),
    );
  }

  Widget emptyCartView() {
    return Stack(
      children: [
        buildBackground(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Keranjang kosong!", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget cartListView(int totalHarga) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: loadProductsFromFirebase,
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                final data = productData[item["uid"]];

                if (data == null) {
                  return ListTile(
                    title: const Text("Produk telah dihapus dari database"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          cart.removeAt(index);
                        });
                      },
                    ),
                  );
                }

                final price = int.tryParse(data.price ?? "0") ?? 0;

                return Card(
                  color: AppColors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: data.images != null && data.images!.isNotEmpty
                          ? Image.network(
                              data.images!.first,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                            ),
                    ),

                    title: Text(
                      data.product ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    subtitle: Text(
                      formatRupiah(price),
                      style: TextStyle(
                        color: AppColors.shape4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final maxStock =
                                int.tryParse(data.stock.toString()) ?? 0;

                            if (item["quantity"] >= maxStock) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Stok tidak mencukupi"),
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
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    formatRupiah(totalHarga),
                    style: TextStyle(
                      color: AppColors.shape4,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                      builder: (_) => const CheckoutFirebaseScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shape4.withOpacity(0.75),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
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

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background4),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
