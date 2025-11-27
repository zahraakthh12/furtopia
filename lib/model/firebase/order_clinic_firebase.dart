import 'dart:convert';

class ClinicBookingModel {
  String? uid; // ID booking
  String? userId; // ID user Firebase
  String? petId; // ID hewan (optional)

  // SERVICE INFO
  String? invoice;
  String? invoiceDate;
  String? serviceId; // ID layanan
  String? serviceName; // Nama layanan (ex: Grooming Basah)
  String? category; // Home Service / In-Clinic
  String? price;

  // BOOKING INFO
  String? address; // hanya untuk Home Service
  String? date; // yyyy-MM-dd
  String? time; // 13:00
  String? status; // pending, process, done, cancelled

  String? createdAt;
  String? updatedAt;

  ClinicBookingModel({
    this.uid,
    this.userId,
    this.petId,
    this.invoice,
    this.invoiceDate,
    this.serviceId,
    this.serviceName,
    this.category,
    this.price,
    this.address,
    this.date,
    this.time,
    this.status = "pending",
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "userId": userId,
      "petId": petId,
      'invoice': invoice,
      "invoiceDate": invoiceDate,
      "serviceId": serviceId,
      "serviceName": serviceName,
      "category": category,
      "price": price,
      "address": address,
      "date": date,
      "time": time,
      "status": status,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory ClinicBookingModel.fromMap(Map<String, dynamic> map) {
    return ClinicBookingModel(
      uid: map["uid"],
      userId: map["userId"],
      petId: map["petId"],
      invoice: map["invoice"],
      invoiceDate: map["invoiceDate"],
      serviceId: map["serviceId"],
      serviceName: map["serviceName"],
      category: map["category"],
      price: map["price"],
      address: map["address"],
      date: map["date"],
      time: map["time"],
      status: map["status"],
      createdAt: map["createdAt"],
      updatedAt: map["updatedAt"],
    );
  }

  String toJson() => json.encode(toMap());
  factory ClinicBookingModel.fromJson(String src) =>
      ClinicBookingModel.fromMap(json.decode(src));
}
