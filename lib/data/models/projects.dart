import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;

  final DateTime createdAt;
  final String officialUrl;
  final Map<String, String> installationUrls;

  final List<String> keywords;
  final List<String> languages;
  final List<String> screenshotsPics;
  final List<String> unreadAnswersIds;
  final List<String> feedbackAssessmentIds;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.officialUrl,
    required this.installationUrls,
    required this.keywords,
    required this.languages,
    required this.screenshotsPics,
    required this.unreadAnswersIds,
    required this.feedbackAssessmentIds,
  }) {
    assert(id.isNotEmpty);
    assert(name.isNotEmpty);
    assert(description.isNotEmpty);
    assert(category.isNotEmpty);
    assert(officialUrl.isNotEmpty);
    assert(keywords.isNotEmpty);
    assert(languages.isNotEmpty);
  }

  // function to create JSON from project
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'created_at': createdAt,
      'official_url': officialUrl,
      'installation_urls': installationUrls,
      'keywords': keywords,
      'languages': languages,
      'screenshots_pics': screenshotsPics,
      'unread_answers_ids': unreadAnswersIds,
      'feedback_assessment_ids': feedbackAssessmentIds,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      createdAt: json['created_at'].toDate(),
      officialUrl: json['official_url'],
      installationUrls: json['installation_urls'],
      keywords: json['keywords'],
      languages: json['languages'],
      screenshotsPics: json['screenshots_pics'],
      unreadAnswersIds: json['unread_answers_ids'],
      feedbackAssessmentIds: json['feedback_assessment_ids'],
    );
  }

  factory Project.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return Project(
      id: documentSnapshot.id,
      name: documentSnapshot['name'],
      description: documentSnapshot['description'],
      category: documentSnapshot['category'],
      createdAt: documentSnapshot['created_at'].toDate(),
      officialUrl: documentSnapshot['official_url'],
      installationUrls: documentSnapshot['installation_urls'],
      keywords: documentSnapshot['keywords'],
      languages: documentSnapshot['languages'],
      screenshotsPics: documentSnapshot['screenshots_pics'],
      unreadAnswersIds: documentSnapshot['unread_answers_ids'],
      feedbackAssessmentIds: documentSnapshot['feedback_assessment_ids'],
    );
  }

  @override
  // Important: the createdAt field is not included in the props list.
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        officialUrl,
        installationUrls,
        keywords,
        languages,
        screenshotsPics,
        unreadAnswersIds,
        feedbackAssessmentIds,
      ];
}
