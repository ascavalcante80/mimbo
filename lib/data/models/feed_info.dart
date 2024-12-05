import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class FeedInfo extends Equatable {
  late final String id;
  final String ownerId;
  DateTime dateCursor;
  List<String> testsIdsSeen;
  String? testInProgressId;

  FeedInfo({
    required this.ownerId,
    required this.dateCursor,
    required this.testsIdsSeen,
    required this.testInProgressId,
  }) {
    assert(id.trim().isNotEmpty);
    assert(ownerId.trim().isNotEmpty);
    id = ownerId;
  }

  factory FeedInfo.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return FeedInfo.fromJson(data);
  }

  factory FeedInfo.fromJson(Map<String, dynamic> json) {
    return FeedInfo(
      ownerId: json['owner_id'],
      dateCursor: json['date_cursor'].toDate(),
      testsIdsSeen: List<String>.from(json['tests_ids_seen']),
      testInProgressId: json['test_in_progress_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'date_cursor': dateCursor,
      'tests_ids_seen': testsIdsSeen,
      'test_in_progress_id': testInProgressId,
    };
  }

  @override
  // Note: The `dateCursor` field is not included in the `props` list.
  List<Object?> get props => [id, ownerId, testsIdsSeen, testInProgressId];
}
