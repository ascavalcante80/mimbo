import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../constants.dart';

class FormFeedback extends Equatable {
  final String id;
  final String userId;
  final String projectId;
  final String openTestId;
  final DateTime createdAt;
  String? openFeedback;
  final FeedbackOptions feedbackOption;

  FormFeedback({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.openTestId,
    required this.openFeedback,
    required this.feedbackOption,
    required this.createdAt,
  });

  factory FormFeedback.fromJson(Map<String, dynamic> json) {
    return FormFeedback(
      id: json['id'],
      userId: json['userId'],
      projectId: json['projectId'],
      openTestId: json['openTestId'],
      openFeedback: json['openFeedback'],
      feedbackOption: FeedbackOptions.values[json['feedbackOption']],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  factory FormFeedback.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return FormFeedback(
      id: documentSnapshot.id,
      userId: documentSnapshot['userId'],
      projectId: documentSnapshot['projectId'],
      openTestId: documentSnapshot['openTestId'],
      openFeedback: documentSnapshot['openFeedback'],
      feedbackOption:
          FeedbackOptions.values[documentSnapshot['feedbackOption']],
      createdAt: documentSnapshot['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'projectId': projectId,
      'openTestId': openTestId,
      'openFeedback': openFeedback,
      'feedbackOption': feedbackOption.name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  // Important to notice, the createdAt field is not included in the props list.
  List<Object?> get props =>
      [id, userId, projectId, openTestId, openFeedback, feedbackOption];
}
