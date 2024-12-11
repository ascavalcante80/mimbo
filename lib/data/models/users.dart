import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../constants.dart';

class MimUser extends Equatable {
  final String id;
  final String username;
  final String name;
  final DateTime createdAt;
  final DateTime birthdate;
  final UserGender gender;
  final List<String> projectIds;

  MimUser({
    required this.id,
    required this.username,
    required this.name,
    required this.createdAt,
    required this.birthdate,
    required this.gender,
    required this.projectIds,
  }) {
    assert(id.trim().isNotEmpty);
    assert(name.trim().isNotEmpty);
    assert(username.trim().isNotEmpty);
  }

  MimUser copyWith(MimUser mimUserToCopy) {
    return MimUser(
      id: mimUserToCopy.id,
      username: mimUserToCopy.username,
      name: mimUserToCopy.name,
      createdAt: mimUserToCopy.createdAt,
      birthdate: mimUserToCopy.birthdate,
      gender: mimUserToCopy.gender,
      projectIds: List<String>.from(mimUserToCopy.projectIds),
    );
  }

  factory MimUser.fromJson(Map<String, dynamic> json) {
    return MimUser(
      id: json['id'],
      username: json['username'],
      createdAt: json['created_at'].toDate(),
      birthdate: json['birthdate'].toDate(),
      name: json['name'],
      gender: stringToGender(json['gender']),
      projectIds: List<String>.from(json['project_ids']),
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
      case 'notBinary':
        return UserGender.notBinary;
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
      projectIds: List<String>.from(documentSnapshot['project_ids']),
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
      'project_ids': List<String>.from(projectIds),
    };
  }

  // Attention: createdAt is not included in the props list! This field is not
  // is created using FieldValue serverTimestamp. So, it is not possible to
  // compare it during tests.
  @override
  List<Object?> get props =>
      [id, username, name, birthdate, gender, projectIds];
}
