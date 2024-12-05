import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../constants.dart';

class FormFeedback extends Equatable {
  final String id;
  final String userId;
  final String projectId;
  final String openTestId;
  final DateTime createdAt;
  final String? openFeedback;
  final FeedbackOptions feedbackOption;

  FormFeedback({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.openTestId,
    required this.openFeedback,
    required this.feedbackOption,
    required this.createdAt,
  }){
    assert(id.isNotEmpty);
    assert(userId.isNotEmpty);
    assert(projectId.isNotEmpty);
    assert(openTestId.isNotEmpty);
  }

  factory FormFeedback.fromJson(Map<String, dynamic> json) {
    return FormFeedback(
      id: json['id'],
      userId: json['user_id'],
      projectId: json['project_id'],
      openTestId: json['open_test_id'],
      openFeedback: json['open_feedback'],
      feedbackOption: FeedbackOptions.values[json['feedback_option']],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  factory FormFeedback.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return FormFeedback(
      id: documentSnapshot.id,
      userId: documentSnapshot['user_id'],
      projectId: documentSnapshot['project_id'],
      openTestId: documentSnapshot['open_test_id'],
      openFeedback: documentSnapshot['open_feedback'],
      feedbackOption:
          FeedbackOptions.values[documentSnapshot['feedback_option']],
      createdAt: documentSnapshot['created_at'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'project_id': projectId,
      'open_test_id': openTestId,
      'open_feedback': openFeedback,
      'feedback_option': feedbackOption.name,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  @override
  // Important to notice, the createdAt field is not included in the props list.
  List<Object?> get props =>
      [id, userId, projectId, openTestId, openFeedback, feedbackOption];
}
