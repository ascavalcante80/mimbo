import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MimCredit extends Equatable {
  final String id;
  final DateTime createdAt;
  final String attributedToTestId;
  final String earnedWithTestId;
  final String earnedByUserId;

  // filled when the credit is used
  DateTime? consumedAt;
  String? consumedWithAnswerId;

  MimCredit({
    required this.id,
    required this.createdAt,
    required this.attributedToTestId,
    required this.consumedAt,
    required this.consumedWithAnswerId,
    required this.earnedWithTestId,
    required this.earnedByUserId,
  });

  factory MimCredit.fromJson(Map<String, dynamic> json) {
    return MimCredit(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      attributedToTestId: json['testId'],
      consumedAt: DateTime.parse(json['usedAt']),
      consumedWithAnswerId: json['consumedWithAnswerId'],
      earnedWithTestId: json['earnedWithTestId'],
      earnedByUserId: json['earnedByUserId'],
    );
  }

  factory MimCredit.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    {
      return MimCredit(
        id: documentSnapshot.id,
        createdAt: documentSnapshot['createdAt'],
        attributedToTestId: documentSnapshot['testId'],
        consumedAt: documentSnapshot['usedAt'],
        consumedWithAnswerId: documentSnapshot['consumedWithAnswerId'],
        earnedWithTestId: documentSnapshot['earnedWithTestId'],
        earnedByUserId: documentSnapshot['earnedByUserId'],
      );
    }
  }

  @override
  // Important: the 'createdAt' and 'usedAt' fields are not included in the
  // props list
  List<Object?> get props => [
        id,
        attributedToTestId,
        consumedWithAnswerId,
        earnedWithTestId,
        earnedByUserId,
      ];
}

class CreditsWallet {
  final List<MimCredit> mimCredits;
  late Map<String, MimCredit> wallet;

  CreditsWallet({
    required this.mimCredits,
  }) {
    wallet = Map.fromIterable(mimCredits, key: (credit) => credit.id);
  }

  void consumeAvailableCredit(String answerId) {
    try {
      final credit = mimCredits.firstWhere(
        (credit) => credit.consumedAt == null,
      );

      credit.consumedAt = DateTime.now();
      credit.consumedWithAnswerId = answerId;
    } on StateError {
      throw NoCreditsAvailableException;
    }
  }

  int getAvailableCredits() {
    return mimCredits.where((credit) => credit.consumedAt == null).length;
  }

  int getConsumedCredits() {
    return mimCredits.where((credit) => credit.consumedAt != null).length;
  }

  void addCredit(MimCredit credit) {
    if (wallet.containsKey(credit.id)) {
      throw Exception("Credit already exists in the wallet");
    } else {
      mimCredits.add(credit);
      wallet[credit.id] = credit;
    }
  }
}

class NoCreditsAvailableException implements Exception {
  final String message = "No credits available to consume";

  NoCreditsAvailableException(message);
}
