import 'package:flutter/material.dart';
import 'package:furtopia/navigation/bottom_nav.dart';
import 'package:furtopia/service/shop_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:furtopia/model/firebase/shop_firebase_model.dart';
import 'package:furtopia/memory/cart_memory.dart';

class PetShopFirebaseScreen extends StatefulWidget {
  const PetShopFirebaseScreen({super.key});

  @override
  State<PetShopFirebaseScreen> createState() => _PetShopFirebaseScreenState();
}

class _PetShopFirebaseScreenState extends State<PetShopFirebaseScreen> {
  String activeCategory = "all";
  String searchQuery = "";
  final customFont = 'Poppins';

  List<Map<String, String>> categories = [
    {"id": "all", "name": "Semua"},
    {"id": "food", "name": "Makanan"},
    {"id": "toys", "name": "Mainan"},
    {"id": "grooming", "name": "Perawatan"},
    {"id": "accessories", "name": "Aksesoris"},
  ];

  String formatRupiah(String price) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(int.tryParse(price) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pet Shop",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: customFont),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          },
        ),
      ),

      // 🔥 Ambil dari Firebase
      body: FutureBuilder<List<ShopFirebaseModel>>(
        future: ShopFirebaseService.getAllProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ShopFirebaseModel> products = snapshot.data!;

          // Filter kategori
          final filteredByCategory = products.where((p) {
            return activeCategory == "all" || p.category == activeCategory;
          });

          // Filter search
          final filteredProducts = filteredByCategory.where((p) {
            return searchQuery.isEmpty ||
                (p.product ?? "").toLowerCase().contains(
                  searchQuery.toLowerCase(),
                );
          }).toList();

          return Column(
            children: [
              // 🔍 Search bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Cari produk...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // 🏷️ Categories
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final selected = cat["id"] == activeCategory;

                    return GestureDetector(
                      onTap: () => setState(() {
                        activeCategory = cat["id"]!;
                      }),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: selected
                              ? LinearGradient(
                                  colors: [
                                    AppColors.shape4.withOpacity(0.75),
                                    AppColors.shape5.withOpacity(0.75),
                                  ],
                                )
                              : null,
                          color: selected ? null : Colors.grey[200],
                        ),
                        child: Center(
                          child: Text(
                            cat["name"]!,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // 🛒 Product Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final p = filteredProducts[index];

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + index * 50),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔥 Firebase Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: p.images != null && p.images!.isNotEmpty
                                ? Image.network(
                                    p.images!.first,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.pets,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ),

                          // TEXT SECTION
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.product ?? "-",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Kategori: ${p.category ?? "-"}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatRupiah(p.price ?? "0"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.shape4.withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // 🛒 ADD TO CART
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.shape4
                                        .withOpacity(0.75),
                                    minimumSize: const Size(
                                      double.infinity,
                                      30,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Jika produk sudah ada di cart
                                    final index = cart.indexWhere(
                                      (item) => item["product"] == p.product,
                                    );

                                    if (index != -1) {
                                      cart[index]["quantity"]++;
                                    } else {
                                      cart.add({
                                        "product": p.product,
                                        "price": int.tryParse(p.price ?? "0"),
                                        "image": p.images?.first,
                                        "quantity": 1,
                                      });
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          "Ditambahkan ke keranjang!",
                                        ),
                                        backgroundColor: AppColors.shape4,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: AppColors.white,
                                  ),
                                  label: const Text(
                                    "Keranjang",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
