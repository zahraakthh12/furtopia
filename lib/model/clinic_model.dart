import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClinicModel {
  int? id;
  String service;
  String servicetype;
  String schedule;
  ClinicModel({
    this.id,
    required this.service,
    required this.servicetype,
    required this.schedule,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'service': service,
      'servicetype': servicetype,
      'schedule': schedule,
    };
  }

  factory ClinicModel.fromMap(Map<String, dynamic> map) {
    return ClinicModel(
      id: map['id'] as int,
      service: map['service'] as String,
      servicetype: map['servicetype'] as String,
      schedule: map['schedule'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClinicModel.fromJson(String source) =>
      ClinicModel.fromMap(json.decode(source) as Map<String, dynamic>);
}