import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/memory/cart_memory.dart';
import 'package:furtopia/model/sql/shop_model.dart';
import 'package:furtopia/navigation/bottom_nav.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/sql/petshop/cart_screen.dart';
import 'package:intl/intl.dart';

class PetShopScreen extends StatefulWidget {
  const PetShopScreen({super.key});

  @override
  State<PetShopScreen> createState() => _PetShopScreenState();
}

class _PetShopScreenState extends State<PetShopScreen> {
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
        backgroundColor: AppColors.shape4.withOpacity(
          0.75,
        ), // warna pink konsisten
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<ShopModel>>(
        future: DBHelper.getAllOrder(),
        builder: (context, snapshot) {
          List<ShopModel> products = [];
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            products = snapshot.data!;
          } else {
            // fallback default products
            products = [
              ShopModel(
                id: 1,
                product: "Royal Canin Persian Adult 2 kg",
                category: "food",
                price: "385000",
                image: AppImages.royalcanin,
              ),
              ShopModel(
                id: 2,
                product: "Shampoo Anti Kutu Premium",
                category: "grooming",
                price: "45000",
                image: AppImages.shampoo,
              ),
              ShopModel(
                id: 3,
                product: "Mainan Bola Interaktif",
                category: "toys",
                price: "85000",
                image: AppImages.bola,
              ),
              ShopModel(
                id: 4,
                product: "Tempat Tidur Premium",
                category: "accessories",
                price: "450000",
                image: AppImages.kasur,
              ),
            ];
          }

          final filteredProducts = products
              .where(
                (p) => activeCategory == "all" || p.category == activeCategory,
              )
              .where(
                (p) =>
                    searchQuery.isEmpty ||
                    p.product.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();

          return Column(
            children: [
              // Search bar
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
              // Categories
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
              // Product Grid
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
                    final product = filteredProducts[index];
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
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              product.image,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.product,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Kategori: ${product.category}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatRupiah(product.price),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.shape4.withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(height: 6),
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
                                    final index = cart.indexWhere(
                                      (item) =>
                                          item["product"] == product.product,
                                    );
                                    if (index != -1) {
                                      cart[index]["quantity"]++;
                                    } else {
                                      cart.add({
                                        "product": product.product,
                                        "price": int.parse(product.price),
                                        "image": product.image,
                                        "quantity": 1,
                                      });
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
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
