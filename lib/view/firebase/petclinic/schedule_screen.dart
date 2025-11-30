import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furtopia/model/firebase/clinic_firebase_model.dart';
import 'package:furtopia/model/firebase/order_clinic_firebase.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/service/clinicbooking_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petclinic/invoice_screen.dart';
import 'package:intl/intl.dart';

class BookingDateTimeScreen extends StatefulWidget {
  final ClinicFirebaseModel service; // data layanan klinik yang akan dibooking
  final String? address; // alamat untuk layanan Home Service
  final PetFirebaseModel pet; // data hewan peliharaan yang akan dibooking

  const BookingDateTimeScreen({
    super.key,
    required this.service,
    required this.pet,
    this.address,
  });

  @override
  State<BookingDateTimeScreen> createState() => _BookingDateTimeScreenState();
}

class _BookingDateTimeScreenState extends State<BookingDateTimeScreen> {
  DateTime? selectedDate; // tanggal yang dipilih
  String? selectedTime; // waktu yang dipilih

  bool loading = false; // status loading saat submit booking

  // daftar slot waktu yang tersedia untuk booking
  List<String> timeSlots = [
    "09:00",
    "10:00",
    "11:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
  ];

  // fungsi untuk menghasilkan nomor invoice unik 
  Future<String> generateInvoice() async {
    String datePart = DateFormat("yyyyMMdd").format(DateTime.now()); // bagian tanggal dari invoice
    String serviceId = widget.service.uid ?? "0"; // ID layanan

    final snap = await FirebaseFirestore.instance // menghitung jumlah booking pada hari ini
        .collection("clinic_bookings") // koleksi booking klinik
        .where("invoiceDate", isEqualTo: datePart) // filter berdasarkan tanggal invoice
        .get(); // ambil data snapshot

    int countToday = snap.docs.length + 1; // hitung jumlah booking hari ini dan tambahkan 1 untuk booking baru
    String padded = countToday.toString().padLeft(4, "0"); // pad angka dengan nol di depan hingga 4 digit

    return "INV-$datePart-$serviceId-$padded"; // format nomor invoice
  }

  // fungsi untuk mengirim data booking ke Firebase
  Future<void> submitBooking() async {
    if (selectedDate == null || selectedTime == null) { // validasi input tanggal dan waktu
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih tanggal & waktu."),
          backgroundColor: Colors.red,
        ),
      );
      return; // hentikan eksekusi jika input tidak valid
    }

    setState(() => loading = true); // set status loading menjadi true

    final invoice = await generateInvoice(); // buat nomor invoice baru

    // buat model booking dengan data yang diperlukan
    final booking = ClinicBookingModel(
      userId: FirebaseAuth.instance.currentUser?.uid ?? "UNKNOWN", // ID pengguna saat ini atau "UNKNOWN" jika tidak tersedia
      petId: widget.pet.uid, // ID hewan peliharaan yang akan dibooking
      serviceId: widget.service.uid,
      serviceName: widget.service.product,
      category: widget.service.category,
      price: widget.service.price,
      address: widget.address,
      date: DateFormat("yyyy-MM-dd").format(selectedDate!), // format tanggal booking
      time: selectedTime,
      status: "pending", // status awal booking
      invoice: invoice,
      invoiceDate: DateFormat("yyyyMMdd").format(DateTime.now()), // bagian tanggal untuk invoice
    );

    await ClinicBookingService.createBooking(booking); // kirim data booking ke Firebase

    setState(() => loading = false); // set status loading menjadi false

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pesanan berhasil dibuat"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClinicInvoiceScreen(booking: booking)), // navigasi ke layar invoice dengan data booking
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          "Pilih Tanggal & Waktu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        elevation: 0, 
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.shape4,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.service.product ?? "-",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.service.category ?? "-",
                          style: TextStyle(
                            color: AppColors.shape4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // tampilkan alamat jika ada 
            if (widget.address != null) ...[
              Text(
                "Alamat Kamu",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.shape4,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.shape2.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.address!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 22),
            ],

            Text(
              "Tanggal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.shape4,
              ),
            ),
            const SizedBox(height: 8),

            // pemilihan tanggal booking
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                );

                // jika tanggal dipilih, setel tanggal terpilih
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null // tampilkan teks default jika belum memilih tanggal
                          ? "Pilih tanggal booking..."
                          : DateFormat("dd MMM yyyy").format(selectedDate!),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.calendar_today, color: AppColors.shape4),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Waktu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.shape4,
              ),
            ),
            const SizedBox(height: 12),

            
            // pemilihan waktu booking
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((time) {
                final selected = selectedTime == time; // cek apakah slot waktu ini terpilih

                // buat widget untuk setiap slot waktu
                return GestureDetector(
                  onTap: () => setState(() => selectedTime = time), // setel waktu terpilih saat slot diketuk
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.shape4 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.shape4 : Colors.black26,
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(), // konversi hasil map ke dalam list widget
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loading ? null : submitBooking, // nonaktifkan tombol saat loading
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.shape4,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Konfirmasi Booking",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
