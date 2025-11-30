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
  bool loading = true; // menandakan apakah data masih dimuat
  Map<String, ShopFirebaseModel?> productData = {}; // menyimpan data produk berdasarkan UID

  @override
  // Inisialisasi dan muat data produk dari Firebase saat layar dibuat
  void initState() {
    super.initState();
    loadProductsFromFirebase();
  }

  // Muat data produk dari Firebase berdasarkan item di keranjang
  Future<void> loadProductsFromFirebase() async {
    loading = true;
    setState(() {});

    productData.clear(); // bersihkan data produk sebelumnya

    for (var item in cart) {
      final uid = item["uid"]; // ambil UID produk dari item keranjang

      // lewati jika UID null atau kosong
      if (uid == null || uid.toString().isEmpty) continue;

      // ambil data produk dari Firebase dan simpan dalam peta productData
      final product = await ShopFirebaseService.getProduct(uid);
      productData[uid] = product;
    }

    loading = false; // data selesai dimuat
    setState(() {});
  }

  // Format angka menjadi format Rupiah
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
      return Center(child: CircularProgressIndicator()); // tampilkan indikator loading saat data dimuat
    }

    // Tampilkan tampilan keranjang kosong jika tidak ada item
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
        body: emptyCartView(), // tampilkan keranjang kosong
      );
    }

    // Hitung total harga semua item dalam keranjang
    int totalHarga = 0; // inisialisasi total harga

    for (var item in cart) {
      final data = productData[item["uid"]]; // ambil data produk berdasarkan UID

      // jika data produk ditemukan, hitung total harga
      if (data != null) {
        final price = int.tryParse(data.price ?? "0") ?? 0; // ambil harga produk
        final qty = int.tryParse(item["quantity"].toString()) ?? 1; // ambil jumlah produk dalam keranjang

        totalHarga += price * qty; // tambahkan ke total harga
      }
    }

    // tampilan keranjang dengan daftar item dan total harga
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
          buildBackground(), 
          Container(
            color: Colors.white.withOpacity(0), 
            child: cartListView(totalHarga),
          ),
        ],
      ),
    );
  }

  // widget halaman keranjang kosong
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

  // widget halaman terdapat produk
  Widget cartListView(int totalHarga ) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: loadProductsFromFirebase, // fungsi refresh data produk
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                final data = productData[item["uid"]];

                // jika data produk tidak ditemukan, akan ditampilkan pesan produk dihapus
                if (data == null) {
                  return ListTile(
                    title: const Text("Produk telah dihapus dari database"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          cart.removeAt(index); // hapus item dari keranjang
                        });
                      },
                    ),
                  );
                }

                final price = int.tryParse(data.price ?? "0") ?? 0; // ambil harga produk

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
                                item["quantity"]--; // kurangi jumlah item
                              } else {
                                cart.removeAt(index); // hapus item jika jumlahnya 0
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
                                int.tryParse(data.stock.toString()) ?? 0; // ambil stok maksimum produk

                            if (item["quantity"] >= maxStock) { // cek apakah jumlah item melebihi stok
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Stok tidak mencukupi"),
                                  backgroundColor: AppColors.shape4,
                                ),
                              );
                              return; // hentikan eksekusi jika stok tidak mencukupi
                            }

                            setState(() {
                              item["quantity"]++; // tambahkan jumlah item
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

        // Bagian total harga dan tombol checkout
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
                      builder: (_) => const CheckoutFirebaseScreen(), // navigasi ke layar checkout
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

  // membuat background
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
