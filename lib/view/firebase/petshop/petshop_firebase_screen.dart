import 'package:flutter/material.dart';
import 'package:furtopia/navigation/bottom_nav_firebase.dart';
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
  String activeCategory = "all"; // kategori yang sedang aktif
  String searchQuery = ""; // query pencarian
  bool loading = true; // status loading data
  List<ShopFirebaseModel> products = []; // semua produk dari firebase
  List<ShopFirebaseModel> filteredProducts = []; // produk yang sudah difilter berdasarkan kategori dan pencarian

  List<Map<String, String>> categories = [
    {"id": "all", "name": "Semua"},
    {"id": "food", "name": "Makanan"},
    {"id": "grooming", "name": "Perawatan"},
    {"id": "accessories", "name": "Aksesoris"},
  ]; // daftar kategori produk

  @override
  // inisialisasi state dan memuat produk dari Firebase saat widget dibuat
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => loading = true);  // mulai loading

    try {
      products = await ShopFirebaseService.getAllProducts(); // ambil semua produk dari Firebase
      applyFilters(); // terapkan filter setelah memuat produk
    } catch (e) {
      print("ERROR FETCH PRODUCT: $e"); // cetak error jika gagal memuat produk
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat produk")));
    }

    setState(() => loading = false); // selesai loading
  }

  void applyFilters() {
    List<ShopFirebaseModel> list = products;

    // filter kategori
    if (activeCategory != "all") {
      list = list.where((p) => p.category == activeCategory).toList(); // filter berdasarkan kategori yang dipilih
    }

    // filter pencarian
    if (searchQuery.isNotEmpty) {
      list = list
          .where(
            (p) => (p.product ?? "").toLowerCase().contains(
              searchQuery.toLowerCase(), // filter berdasarkan query pencarian
            ),
          )
          .toList(); // konversi hasil filter ke list
    }

    setState(() => filteredProducts = list); // perbarui state dengan produk yang sudah difilter
  }

  String formatRupiah(String price) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ); // format mata uang Rupiah
    return formatter.format(int.tryParse(price) ?? 0); // kembalikan harga yang sudah diformat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Pet Shop", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavFirebase()), // navigasi ke beranda
            );
          },
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      applyFilters(); // terapkan filter saat query pencarian berubah
                    },
                    decoration: InputDecoration(
                      hintText: "Cari produk...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // Category
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final selected = cat["id"] == activeCategory; // cek apakah kategori ini yang sedang aktif

                      return GestureDetector(
                        onTap: () {
                          activeCategory = cat["id"]!;
                          applyFilters(); // terapkan filter saat kategori berubah
                        },
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
                                : null, // jika tidak dipilih, tidak ada gradien
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

                // product grid
                Expanded(
                  child: filteredProducts.isEmpty // jika tidak ada produk yang ditemukan
                      ? const Center(child: Text("Produk tidak ditemukan"))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.49,
                              ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final p = filteredProducts[index]; // ambil produk yang sudah difilter

                            return productCard(p); // tampilkan kartu produk
                          },
                        ),
                ),
              ],
            ),
    );
  }

  // membuat kartu produk
  Widget productCard(ShopFirebaseModel p) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: p.images != null && p.images!.isNotEmpty // jika ada gambar
                ? Image.network(
                    p.images!.first, // tampilkan gambar pertama dari daftar gambar
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.pets, size: 40, color: Colors.grey),
                    ),
                  ),
          ),

          // detail produk
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.product ?? "-",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // potong teks jika terlalu panjang
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    "Kategori: ${p.category}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${p.rating?.toStringAsFixed(1) ?? "0.0"}", // tampilkan rating dengan 1 desimal
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    "Stok: ${p.stock}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    formatRupiah(p.price ?? "0"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.shape4.withOpacity(0.75),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // tombol keranjang
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shape4.withOpacity(0.75),
                minimumSize: const Size(double.infinity, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final idx = cart.indexWhere(
                  (item) => item["product"] == p.product, // cek apakah produk sudah ada di keranjang
                );

                if (idx != -1) {
                  final maxStock = cart[idx]["stock"] ?? 0; // ambil stok maksimum dari produk di keranjang

                  if (cart[idx]["quantity"] >= maxStock) { // jika kuantitas sudah mencapai stok maksimum
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Stok tidak mencukupi"),
                        backgroundColor: AppColors.shape4,
                      ),
                    );
                    return; // keluar dari fungsi tanpa menambah kuantitas
                  }

                  cart[idx]["quantity"]++; // tambahkan kuantitas produk di keranjang
                } else { // jika produk belum ada di keranjang
                  cart.add({
                    "uid": p.uid,
                    "product": p.product,
                    "price": int.tryParse(p.price ?? "0"), // konversi harga ke integer
                    "image": p.images?.first,
                    "quantity": 1, // mulai dengan kuantitas 1
                    "stock": int.tryParse(p.stock.toString()) ?? 0, // konversi stok ke integer
                  }); // tambahkan produk baru ke keranjang
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Ditambahkan ke keranjang!"),
                    backgroundColor: AppColors.shape4,
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: Text(
                p.stock == 0 ? "Stok Habis" : "Keranjang", // tampilkan teks sesuai stok
                style: const TextStyle(
                  fontSize: 12,
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
}
