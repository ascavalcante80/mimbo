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
  }) {
    assert(id.isNotEmpty);
    assert(earnedWithTestId.isNotEmpty);
    assert(earnedByUserId.isNotEmpty);
  }

  factory MimCredit.fromJson(Map<String, dynamic> json) {
    return MimCredit(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      attributedToTestId: json['test_id'],
      consumedAt: DateTime.parse(json['consumed_at']),
      consumedWithAnswerId: json['consumed_with_answer_id'],
      earnedWithTestId: json['earned_with_test_id'],
      earnedByUserId: json['earned_by_user_id'],
    );
  }

  factory MimCredit.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    {
      return MimCredit(
        id: documentSnapshot.id,
        createdAt: documentSnapshot['created_at'].toDate(),
        attributedToTestId: documentSnapshot['test_id'],
        consumedAt: documentSnapshot['consumed_at'].toDate(),
        consumedWithAnswerId: documentSnapshot['consumed_with_answer_id'],
        earnedWithTestId: documentSnapshot['earned_with_test_id'],
        earnedByUserId: documentSnapshot['earned_by_user_id'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'test_id': attributedToTestId,
      'consumed_at': consumedAt,
      'consumed_with_answer_id': consumedWithAnswerId,
      'earned_with_test_id': earnedWithTestId,
      'earned_by_user_id': earnedByUserId,
    };
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
