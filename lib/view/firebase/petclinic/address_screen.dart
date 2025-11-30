import 'package:flutter/material.dart'; // untuk membuat UI Flutter
import 'package:furtopia/model/firebase/clinic_firebase_model.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petclinic/schedule_screen.dart';
import 'package:intl/intl.dart'; // untuk format tanggal dan mata uang

class BookingFirebaseScreen extends StatefulWidget {
  final PetFirebaseModel pet; // untuk menyimpan data hewan peliharaan
  final ClinicFirebaseModel service; // untuk menyimpan data layanan klinik

  const BookingFirebaseScreen({
    super.key,
    required this.service,
    required this.pet,
  });

  @override
  State<BookingFirebaseScreen> createState() => _BookingFirebaseScreenState();
}

class _BookingFirebaseScreenState extends State<BookingFirebaseScreen> {
  final addressC = TextEditingController(); // controller untuk input alamat

  // format harga ke dalam format rupiah
  String formatRupiah(String price) {
    final formatter = NumberFormat.currency(
      locale: "id",
      symbol: "Rp ",
      decimalDigits: 0, // tanpa desimal
    );
    return formatter.format(int.tryParse(price) ?? 0); // mengubah string ke int 
  }

  @override
  Widget build(BuildContext context) {
    final isHomeService = widget.service.category == "Home Service"; // cek kategori layanan apakah Home Service atau In-Clinic Service

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Booking Layanan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.shape4.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.service.product ?? "-",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              widget.service.category ?? "-",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.shape4,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              formatRupiah(widget.service.price ?? "0"),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.shape4.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tampilan input alamat hanya muncul jika layanan adalah Home Service
              if (isHomeService)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alamat Lengkap",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.shape4,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: addressC,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText:
                                "Isi alamat lengkap anda.\n(Jalan, No. Rumah, Kelurahan, Kecamatan, Patokan (opsional))",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Tampilan informasi jika layanan adalah In-Clinic Service
              if (!isHomeService)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Kamu memilih layanan In-Clinic, tidak perlu mengisi alamat.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (isHomeService && addressC.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Alamat wajib diisi untuk Home Service."),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Navigasi ke layar pemilihan jadwal dengan data yang diperlukan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingDateTimeScreen(
                    service: widget.service, // mengirim data layanan
                    pet: widget.pet, // mengirim data hewan peliharaan
                    address: isHomeService ? addressC.text : null, // mengirim alamat jika Home Service
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.shape4,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Lanjut Pilih Jadwal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
