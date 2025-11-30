import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/model/firebase/order_clinic_firebase.dart';
import 'package:furtopia/view/firebase/profil_user/clinic_detail_order.dart';

class ClinicInvoiceScreen extends StatelessWidget {
  final ClinicBookingModel booking; // data booking klinik yang akan ditampilkan

  const ClinicInvoiceScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final adminFee = 10000; // biaya admin tetap
    final servicePrice = int.tryParse(booking.price ?? "0") ?? 0; // harga layanan dari booking
    final total = servicePrice + adminFee; // total biaya yang harus dibayar

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Invoice Booking"),
        backgroundColor: AppColors.shape4.withOpacity(0.8),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invoice",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    booking.invoice ?? "-", // menampilkan nomor invoice
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Detail Booking
            _infoBox(
              title: "Detail Booking",
              children: [
                _item("Layanan", booking.serviceName ?? "-"),
                _item("Kategori", booking.category ?? "-"),
                _item("Tanggal", booking.date ?? "-"),
                _item("Waktu", booking.time ?? "-"),
                if (booking.address != null) _item("Alamat", booking.address!), // tampilkan alamat jika ada
              ],
            ),

            const SizedBox(height: 20),

            // Detail Harga
            _infoBox(
              title: "Rincian Biaya",
              children: [
                _item(
                  "Harga Layanan",
                  "Rp ${NumberFormat("#,###").format(servicePrice)}", // format harga layanan
                ),
                _item("Biaya Admin", "Rp 10.000"), // biaya admin tetap
                const Divider(),
                _item(
                  "Total Bayar",
                  "Rp ${NumberFormat("#,###").format(total)}", // format total biaya
                  bold: true, // cetak tebal untuk total
                ),
              ],
            ),

            const Spacer(),

            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClinicBookingDetailScreen(
                            bookingId: booking.uid!,
                          ), // navigasi ke layar detail booking dengan ID booking
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.shape4,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Lihat Detail Booking",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst); // kembali ke beranda
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.shape4, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Kembali ke Beranda",
                      style: TextStyle(
                        color: AppColors.shape4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan kotak informasi dengan judul dan daftar item
  Widget _infoBox({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // Widget untuk menampilkan satu baris item dengan key dan value
  Widget _item(String key, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
