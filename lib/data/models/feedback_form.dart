import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class FeedbackForm {
  final String id;
  final String userId;
  final String projectId;
  final String openTestId;
  String? openFeedback;
  final FeedbackOptions feedbackOption;

  FeedbackForm({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.openTestId,
    required this.openFeedback,
    required this.feedbackOption,
  });

  factory FeedbackForm.fromJson(Map<String, dynamic> json) {
    return FeedbackForm(
      id: json['id'],
      userId: json['userId'],
      projectId: json['projectId'],
      openTestId: json['openTestId'],
      openFeedback: json['openFeedback'],
      feedbackOption: FeedbackOptions.values[json['feedbackOption']],
    );
  }

  factory FeedbackForm.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return FeedbackForm(
      id: documentSnapshot.id,
      userId: documentSnapshot['userId'],
      projectId: documentSnapshot['projectId'],
      openTestId: documentSnapshot['openTestId'],
      openFeedback: documentSnapshot['openFeedback'],
      feedbackOption:
          FeedbackOptions.values[documentSnapshot['feedbackOption']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'projectId': projectId,
      'openTestId': openTestId,
      'openFeedback': openFeedback,
      'feedbackOption': feedbackOption.name,
    };
  }
}
