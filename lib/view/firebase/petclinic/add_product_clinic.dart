import 'package:furtopia/model/firebase/clinic_firebase_model.dart';

class AddProductClinic {
  static List<ClinicFirebaseModel> productsClinic = [
    ClinicFirebaseModel(
      uid: "1",
      product: "Grooming Basah",
      description: "Layanan grooming basah lengkap untuk semua jenis kucing.",
      price: "120000",
      category: "Home Service",
    ),
    ClinicFirebaseModel(
      uid: "2",
      product: "Grooming Basah",
      description: "Layanan grooming basah lengkap untuk semua jenis kucing.",
      price: "100000",
      category: "In-Clinic Service",
    ),
    ClinicFirebaseModel(
      uid: "3",
      product: "Grooming Kering",
      description: "Perawatan grooming tanpa air, cocok untuk kucing sensitif.",
      price: "80000",
      category: "Home Service",
    ),
    ClinicFirebaseModel(
      uid: "4",
      product: "Grooming Kering",
      description: "Perawatan grooming tanpa air, cocok untuk kucing sensitif.",
      price: "60000",
      category: "In-Clinic Service",
    ),
    ClinicFirebaseModel(
      uid: "5",
      product: "Medical Check-Up",
      description: "Pemeriksaan kesehatan dasar",
      price: "75000",
      category: "Home Service",
    ),
    ClinicFirebaseModel(
      uid: "6",
      product: "Medical Check-Up",
      description: "Pemeriksaan kesehatan dasar",
      price: "75000",
      category: "In-Clinic Service",
    ),
    ClinicFirebaseModel(
      uid: "7",
      product: "Steril Betina",
      description: "Sterilisasi betina",
      price: "360000",
      category: "In-Clinic Service",
    ),
    ClinicFirebaseModel(
      uid: "8",
      product: "Steril Jantan",
      description: "Sterilisasi jantan",
      price: "280000",
      category: "In-Clinic Service",
    ),
  ];
}
