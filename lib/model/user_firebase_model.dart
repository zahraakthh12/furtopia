import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserFirebaseModel {
  String? uid;
  String? fullname;
  String? email;
  String? phone;
  String? createdAt;
  String? updateAt;
  UserFirebaseModel({
    this.uid,
    this.fullname,
    this.email,
    this.phone,
    this.createdAt,
    this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }

  factory UserFirebaseModel.fromMap(Map<String, dynamic> map) {
    return UserFirebaseModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updateAt: map['updateAt'] != null ? map['updateAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFirebaseModel.fromJson(String source) =>
      UserFirebaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
