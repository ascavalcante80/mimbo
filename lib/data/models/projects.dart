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

  Project(
    this.id,
    this.name,
    this.description,
    this.category,
    this.createdAt,
    this.officialUrl,
    this.installationUrls,
    this.keywords,
    this.languages,
    this.screenshotsPics,
    this.unreadAnswersIds,
    this.feedbackAssessmentIds,
  ) {
    assert(id.isNotEmpty);
    assert(name.isNotEmpty);
    assert(description.isNotEmpty);
    assert(category.isNotEmpty);
    assert(officialUrl.isNotEmpty);
    assert(keywords.isNotEmpty);
    assert(languages.isNotEmpty);
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
