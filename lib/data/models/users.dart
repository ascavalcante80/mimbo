import 'package:cloud_firestore/cloud_firestore.dart';

class MimUser {
  String id;
  String username;
  DateTime createdAt;
  DateTime birthDate;

  MimUser({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.birthDate,
  });

  factory MimUser.fromJson(Map<String, dynamic> json) {
    return MimUser(
      id: json['id'],
      username: json['username'],
      createdAt: json['createdAt'],
      birthDate: json['birthDate'],
    );
  }

  factory MimUser.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return MimUser(
      id: documentSnapshot.id,
      username: documentSnapshot['username'],
      createdAt: documentSnapshot['createdAt'],
      birthDate: documentSnapshot['birthDate'],
    );
  }
}
