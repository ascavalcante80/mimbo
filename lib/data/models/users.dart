import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class MimUser {
  String id;
  String username;
  DateTime createdAt;
  DateTime birthDate;
  UserGender gender;

  MimUser({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.birthDate,
    required this.gender,
  });

  factory MimUser.fromJson(Map<String, dynamic> json) {
    return MimUser(
      id: json['id'],
      username: json['username'],
      createdAt: json['createdAt'],
      birthDate: json['birthDate'],
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
        return UserGender.notSpecified;
      case 'other':
        return UserGender.other;
    }
  }

  factory MimUser.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return MimUser(
      id: documentSnapshot.id,
      username: documentSnapshot['username'],
      createdAt: documentSnapshot['createdAt'],
      birthDate: documentSnapshot['birthDate'],
      gender: stringToGender(documentSnapshot['gender']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'createdAt': createdAt,
      'birthDate': birthDate,
    };
  }
}
