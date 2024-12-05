import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MimCredit extends Equatable {
  final String id;
  final DateTime createdAt;
  final String earnedWithTestId;
  final String earnedByUserId;

  // filled when the credit is used
  DateTime? consumedAt;
  String? attributedToTestId;
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
    assert(attributedToTestId != earnedWithTestId);
    assert(attributedToTestId != consumedWithAnswerId);
    assert(earnedWithTestId != consumedWithAnswerId);
    if (consumedAt != null) {
      assert(createdAt.isBefore(consumedAt!));
    }
  }

  factory MimCredit.fromJson(Map<String, dynamic> json) {
    return MimCredit(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      attributedToTestId: json['attributed_to_test_id'],
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
        attributedToTestId: documentSnapshot['attributed_to_test_id'],
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
      'attributed_to_test_id': attributedToTestId,
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

class CreditsWallet extends Equatable {
  final List<MimCredit> mimCredits;
  late Map<String, MimCredit> _wallet;

  CreditsWallet({
    required this.mimCredits,
  }) {
    _wallet = Map.fromIterable(mimCredits, key: (credit) => credit.id);

    // Ensure that the wallet has the same number of credits as the list -
    // this is a way to ensure that the list has no duplicates ID
    assert(_wallet.keys.length == mimCredits.length);
  }

  Future<void> consumeAvailableCredit(String answerId) async {
    try {
      final credit = mimCredits.firstWhere(
        (credit) => credit.consumedAt == null,
      );

      credit.consumedAt = DateTime.now();
      credit.consumedWithAnswerId = answerId;
    } on StateError {
      throw NoCreditsAvailableException();
    }
  }

  int getTotalOfAvailableCredits() {
    return mimCredits.where((credit) => credit.consumedAt == null).length;
  }

  int getTotalOfConsumedCredits() {
    return mimCredits.where((credit) => credit.consumedAt != null).length;
  }

  Future<void> addCredit(MimCredit credit) async {
    if (credit.consumedAt != null || credit.consumedWithAnswerId != null) {
      throw ErrorTryingAddConsumedCredit();
    }

    if (_wallet.containsKey(credit.id)) {
      throw CreditAlreadyInUseException();
    } else {
      mimCredits.add(credit);
      _wallet[credit.id] = credit;
    }
  }

  @override
  List<Object?> get props => [mimCredits, _wallet];
}

class ErrorTryingAddConsumedCredit implements Exception {
  String errorMessage() => "Cannot add a consumed credit to the wallet";
}

class NoCreditsAvailableException implements Exception {
  String errorMessage() => "No credits available to consume";
}

class CreditAlreadyInUseException implements Exception {
  String errorMessage() => "Credit is already in use";
}
