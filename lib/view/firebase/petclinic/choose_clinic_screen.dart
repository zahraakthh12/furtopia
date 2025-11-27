import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/clinic_firebase_model.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petclinic/add_product_clinic.dart';
import 'package:furtopia/view/firebase/petclinic/address_screen.dart';
import 'package:intl/intl.dart';

class PetClinicChooseServiceScreen extends StatefulWidget {
  final PetFirebaseModel pet;
  const PetClinicChooseServiceScreen({super.key, required this.pet});

  @override
  State<PetClinicChooseServiceScreen> createState() =>
      _PetClinicChooseServiceScreenState();
}

class _PetClinicChooseServiceScreenState
    extends State<PetClinicChooseServiceScreen> {
  String activeCategory = "all";
  String searchQuery = "";

  List<Map<String, String>> categories = [
    {"id": "all", "name": "Semua"},
    {"id": "Home Service", "name": "Home Service"},
    {"id": "In-Clinic Service", "name": "In-Clinic Service"},
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
    List<ClinicFirebaseModel> products = AddProductClinic.productsClinic;

    // Filter kategori
    final filteredByCategory = products.where((p) {
      return activeCategory == "all" || p.category == activeCategory;
    });

    // Filter search
    final filteredProducts = filteredByCategory.where((p) {
      return searchQuery.isEmpty ||
          (p.product ?? "").toLowerCase().contains(searchQuery.toLowerCase());
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

      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Cari layanan...",
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
                  onTap: () => setState(() => activeCategory = cat["id"]!),
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

          // LIST VIEW – bukan grid
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final p = filteredProducts[index];

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
                      // NAMA LAYANAN
                      Text(
                        p.product ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // DESKRIPSI
                      Text(
                        p.description ?? "-",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ⭐ KATEGORI (badge)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.shape2.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          p.category ?? "-",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // HARGA
                      Text(
                        formatRupiah(p.price ?? "0"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.shape4.withOpacity(0.85),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // BUTTON PILIH
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.shape4.withOpacity(0.75),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingFirebaseScreen(
                                  service: p,
                                  pet: widget.pet,
                                ),
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
