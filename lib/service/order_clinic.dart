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

    await docRef.set(booking.toMap());
  }
}
