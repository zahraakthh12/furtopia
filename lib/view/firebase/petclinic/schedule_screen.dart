import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furtopia/model/firebase/clinic_firebase_model.dart';
import 'package:furtopia/model/firebase/order_clinic_firebase.dart';
import 'package:furtopia/model/firebase/pet_firebase_model.dart';
import 'package:furtopia/service/clinic_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/petclinic/invoice_screen.dart';
import 'package:intl/intl.dart';

class BookingDateTimeScreen extends StatefulWidget {
  final ClinicFirebaseModel service;
  final String? address;
  final PetFirebaseModel pet;

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
  DateTime? selectedDate;
  String? selectedTime;

  bool loading = false;

  List<String> timeSlots = [
    "09:00",
    "10:00",
    "11:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
  ];

  // =======================================================
  // 🔥 GENERATE INVOICE: INV-20251127-2-0001
  // =======================================================
  Future<String> generateInvoice() async {
    String datePart = DateFormat("yyyyMMdd").format(DateTime.now());
    String serviceId = widget.service.uid ?? "0";

    final snap = await FirebaseFirestore.instance
        .collection("clinic_bookings")
        .where("invoiceDate", isEqualTo: datePart)
        .get();

    int countToday = snap.docs.length + 1;
    String padded = countToday.toString().padLeft(4, "0");

    return "INV-$datePart-$serviceId-$padded";
  }

  // =======================================================
  // 🔥 SIMPAN BOOKING KE FIREBASE
  // =======================================================
  Future<void> submitBooking() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih tanggal & waktu."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    final invoice = await generateInvoice();

    final booking = ClinicBookingModel(
      userId: FirebaseAuth.instance.currentUser?.uid ?? "UNKNOWN",
      petId: widget.pet.uid,
      serviceId: widget.service.uid,
      serviceName: widget.service.product,
      category: widget.service.category,
      price: widget.service.price,
      address: widget.address,
      date: DateFormat("yyyy-MM-dd").format(selectedDate!),
      time: selectedTime,
      status: "pending",
      invoice: invoice,
      invoiceDate: DateFormat("yyyyMMdd").format(DateTime.now()),
    );

    await ClinicBookingService.createBooking(booking);

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pesanan berhasil dibuat"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClinicInvoiceScreen(booking: booking)),
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
            // CARD INFO SERVICE
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

            // ALAMAT (Jika Home Service)
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

            // PILIH TANGGAL
            Text(
              "Tanggal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.shape4,
              ),
            ),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                );

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
                      selectedDate == null
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

            // TIME SLOT
            Text(
              "Waktu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.shape4,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((time) {
                final selected = selectedTime == time;

                return GestureDetector(
                  onTap: () => setState(() => selectedTime = time),
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
              }).toList(),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      // BUTTON CONFIRM
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loading ? null : submitBooking,
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
