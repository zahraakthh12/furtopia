import 'dart:convert';

class ClinicBookingModel {
  String? uid;
  String? userId;
  String? petId;

  String? invoice;
  String? invoiceDate;
  String? serviceId;
  String? serviceName; 
  String? category; 
  String? price;

  String? address; 
  String? date;
  String? time;
  String? status; 

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
