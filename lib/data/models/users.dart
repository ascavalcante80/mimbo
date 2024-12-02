import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class MimUser {
  String id;
  String username;
  String name;
  DateTime createdAt;
  DateTime birthdate;
  UserGender gender;

  MimUser({
    required this.id,
    required this.username,
    required this.name,
    required this.createdAt,
    required this.birthdate,
    required this.gender,
  });

  factory MimUser.fromJson(Map<String, dynamic> json) {
    return MimUser(
      id: json['id'],
      username: json['username'],
      createdAt: json['created_at'].toDate(),
      birthdate: json['birthdate'].toDate(),
      name: json['name'],
      gender: stringToGender(json['gender']),
    );
  }

  static stringToGender(String genderString) {
    switch (genderString) {
      case 'male':
        return UserGender.male;
      case 'female':
        return UserGender.female;
      case 'notSpecified':
        return UserGender.notBinary;
      case 'other':
        return UserGender.other;
    }
  }

  factory MimUser.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return MimUser(
      id: documentSnapshot.id,
      username: documentSnapshot['username'],
      createdAt: documentSnapshot['created_at'].toDate(),
      birthdate: documentSnapshot['birthdate'].toDate(),
      name: documentSnapshot['name'],
      gender: stringToGender(documentSnapshot['gender']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'created_at': createdAt,
      'birthdate': birthdate,
      'name': name,
      'gender': gender.name,
    };
  }
}
