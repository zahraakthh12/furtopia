import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furtopia/model/firebase/order_clinic_firebase.dart';

class ClinicBookingService {
  static final firestore = FirebaseFirestore.instance;
  static const collection = "clinic_bookings";

  static Future<void> createBooking(ClinicBookingModel booking) async {
    final docRef = firestore.collection(collection).doc();

    booking.uid = docRef.id;
    booking.createdAt = DateTime.now().toIso8601String();
    booking.updatedAt = DateTime.now().toIso8601String();

    // Tambahkan ini
    final today = DateTime.now();
    final datePart =
        "${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";

    final categoryCode = booking.category == "Home Service" ? "HM" : "IC";

    final data = booking.toMap();
    data["datePart"] = datePart;
    data["categoryCode"] = categoryCode;

    await docRef.set(data);
  }

  static Future<String> generateInvoice({
    required String serviceCategory,
  }) async {
    // Tanggal hari ini
    final today = DateTime.now();
    final datePart =
        "${today.year}"
        "${today.month.toString().padLeft(2, '0')}"
        "${today.day.toString().padLeft(2, '0')}";

    // Kode kategori
    final categoryCode = serviceCategory == "Home Service" ? "HM" : "IC";

    final snapshot = await firestore
        .collection(collection)
        .where("datePart", isEqualTo: datePart)
        .where("categoryCode", isEqualTo: categoryCode)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get();

    int runningNumber = 1;

    if (snapshot.docs.isNotEmpty) {
      final lastInvoice = snapshot.docs.first.data()["invoice"];
      final lastNumber = int.parse(lastInvoice.split("-").last);
      runningNumber = lastNumber + 1;
    }

    final numberPart = runningNumber.toString().padLeft(3, "0");

    return "INV-$datePart-$categoryCode-$numberPart";
  }
}
