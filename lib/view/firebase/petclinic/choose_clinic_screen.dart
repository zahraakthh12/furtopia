import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/clinic_firebase_model.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/service/clinic_service.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petclinic/address_screen.dart';
import 'package:intl/intl.dart';

class PetClinicChooseServiceScreen extends StatefulWidget {
  final PetFirebaseModel pet; // untuk menyimpan data hewan peliharaan
  const PetClinicChooseServiceScreen({super.key, required this.pet});

  @override
  State<PetClinicChooseServiceScreen> createState() =>
      _PetClinicChooseServiceScreenState();
}

class _PetClinicChooseServiceScreenState
    extends State<PetClinicChooseServiceScreen> {
  String activeCategory = "all"; // kategori layanan yang aktif
  String searchQuery = ""; // query pencarian layanan

  List<ClinicFirebaseModel> services = []; // daftar layanan klinik
  bool isLoading = true; // status loading data

  List<Map<String, String>> categories = [
    {"id": "all", "name": "Semua"},
    {"id": "Home Service", "name": "Home Service"},
    {"id": "In-Clinic Service", "name": "In-Clinic Service"},
  ];

  @override
  // memuat data layanan saat inisialisasi state
  void initState() {
    super.initState();
    loadServices();
  }

  // fungsi untuk memuat data layanan dari Firebase
  Future<void> loadServices() async {
    final data = await ClinicServiceFirebase.getAllServices(); // ambil semua layanan dari Firebase
    setState(() {
      services = data; // untuk menyimpan data layanan
      isLoading = false; // untuk menandai bahwa data telah dimuat
    });
  }

  // format harga ke dalam format rupiah
  String formatRupiah(String price) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(int.tryParse(price) ?? 0); // mengubah string ke int dan memformat ke rupiah
  }

  @override
  Widget build(BuildContext context) {
    // filter berdasarkan kategori
    final filterCategory = services.where((s) {
      return activeCategory == "all" || s.category == activeCategory;
    });

    // filter berdasarkan pencarian
    final filtered = filterCategory.where((s) {
      return searchQuery.isEmpty ||
          (s.product ?? "").toLowerCase().contains(searchQuery.toLowerCase()); // pencarian tidak sensitif huruf besar/kecil
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          "Pilih Layanan Clinic",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: isLoading // tampilkan indikator loading jika data masih dimuat
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: InputDecoration(
                      hintText: "Cari layanan...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // arah scroll horizontal
                    itemCount: categories.length, // jumlah kategori
                    itemBuilder: (context, index) {
                      final cat = categories[index]; // ambil kategori berdasarkan indeks
                      final selected = cat["id"] == activeCategory;  // cek apakah kategori ini yang aktif

                      return GestureDetector(
                        onTap: () => setState(() => activeCategory = cat["id"]!), // ubah kategori aktif saat diklik
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: selected // jika kategori ini aktif, beri gradasi warna
                                ? LinearGradient(
                                    colors: [
                                      AppColors.shape4.withOpacity(0.75),
                                      AppColors.shape5.withOpacity(0.75),
                                    ],
                                  )
                                : null, // jika tidak aktif, tidak ada gradasi warna
                            color: selected ? null : Colors.grey[200], // warna latar belakang jika tidak aktif
                          ),
                          child: Center(
                            child: Text(
                              cat["name"]!,
                              style: TextStyle(
                                color:
                                    selected ? Colors.white : Colors.black87, // warna teks berdasarkan status aktif
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: filtered.isEmpty // cek apakah daftar layanan yang difilter kosong
                      ? const Center(
                          child: Text(
                            "Layanan tidak ditemukan",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length, // jumlah layanan yang difilter
                          itemBuilder: (context, index) {
                            final s = filtered[index]; // ambil layanan berdasarkan indeks

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
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
                                  Text(
                                    s.product ?? "-",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    s.description ?? "-",
                                    maxLines: 2, // batasi maksimal 2 baris teks
                                    overflow: TextOverflow.ellipsis, // jika teks terlalu panjang, tambahkan elipsis (...)
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.shape2.withOpacity(0.4),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      s.category ?? "-", // tampilkan kategori layanan
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    formatRupiah(s.price ?? "0"), // format harga layanan
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.shape4
                                          .withOpacity(0.85),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.shape4
                                            .withOpacity(0.75),
                                        padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BookingFirebaseScreen(
                                              service: s,
                                              pet: widget.pet,
                                            ), // navigasi ke layar booking dengan data layanan dan hewan peliharaan
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Pilih Layanan",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
