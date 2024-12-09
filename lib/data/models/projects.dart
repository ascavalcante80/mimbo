import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Project extends Equatable {
  late final String id;
  final String ownerId;

  final String name;
  final String description;
  final String category;
  final String officialUrl;

  late final Map<String, String> installationUrls;
  late final DateTime createdAt;

  final List<String> keywords;
  late final List<String> languages;
  late final List<String> screenshotsPics;
  late final List<String> unreadAnswersIds;
  late final List<String> feedbackAssessmentIds;

  Project.emptyProject({
    required this.ownerId,
    required this.name,
    required this.description,
    required this.category,
    required this.officialUrl,
    required this.keywords,
  }) {
    id = 'temp_id';
    createdAt = DateTime.now();
    installationUrls = {};
    screenshotsPics = [];
    unreadAnswersIds = [];
    feedbackAssessmentIds = [];
    languages = ['default'];

    assert(id.trim().isNotEmpty);
    assert(name.trim().isNotEmpty);
    assert(description.trim().isNotEmpty);
    assert(category.isNotEmpty);
    assert(officialUrl.trim().isNotEmpty);
  }

  Project({
    required this.id,
    required this.ownerId,
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
    assert(id.trim().isNotEmpty);
    assert(name.trim().isNotEmpty);
    assert(description.trim().isNotEmpty);
    assert(category.isNotEmpty);
    assert(officialUrl.trim().isNotEmpty);

  }

  // function to create JSON from project
  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
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
      ownerId: json['owner_id'],
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
      ownerId: documentSnapshot['owner_id'],
      name: documentSnapshot['name'],
      description: documentSnapshot['description'],
      category: documentSnapshot['category'],
      createdAt: documentSnapshot['created_at'].toDate(),
      officialUrl: documentSnapshot['official_url'],
      installationUrls:
          Map<String, String>.from(documentSnapshot['installation_urls']),
      keywords: List<String>.from(documentSnapshot['keywords']),
      languages: List<String>.from(documentSnapshot['languages']),
      screenshotsPics: List<String>.from(documentSnapshot['screenshots_pics']),
      unreadAnswersIds:
          List<String>.from(documentSnapshot['unread_answers_ids']),
      feedbackAssessmentIds:
          List<String>.from(documentSnapshot['feedback_assessment_ids']),
    );
  }

  Project copyWithUpdateId(String id) {
    return Project(
      id: id,
      ownerId: ownerId,
      name: name,
      description: description,
      category: category,
      createdAt: createdAt,
      officialUrl: officialUrl,
      installationUrls: installationUrls,
      keywords: keywords,
      languages: languages,
      screenshotsPics: screenshotsPics,
      unreadAnswersIds: unreadAnswersIds,
      feedbackAssessmentIds: feedbackAssessmentIds,
    );
  }

  @override
  // Important: the createdAt field is not included in the props list.
  List<Object?> get props => [
        id,
        ownerId,
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
