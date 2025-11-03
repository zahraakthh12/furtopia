import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClinicModel {
  int? id;
  String service;
  String servicetype;
  String date;
  String time;
  String payment;
  String petdata;
  String address;
  String price;
  ClinicModel({
    this.id,
    required this.service,
    required this.servicetype,
    required this.date,
    required this.time,
    required this.payment,
    required this.petdata,
    required this.address,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'service': service,
      'servicetype': servicetype,
      'date': date,
      'time': time,
      'payment': payment,
      'petdata': petdata,
      'address': address,
      'price': price,
    };
  }

  factory ClinicModel.fromMap(Map<String, dynamic> map) {
    return ClinicModel(
      id: map['id'] as int,
      service: map['service'] as String,
      servicetype: map['servicetype'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      payment: map['payment'] as String,
      petdata: map['petdata'] as String,
      address: map['address'] as String,
      price: map['price'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClinicModel.fromJson(String source) =>
      ClinicModel.fromMap(json.decode(source) as Map<String, dynamic>);
}