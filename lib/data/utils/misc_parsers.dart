import 'package:mimbo/data/constants.dart';

FeedbackOptions getFeedbackOptionFromString(String feedbackOption) {
  switch (feedbackOption) {
    case 'userDoestSpeakTestLanguage':
      return FeedbackOptions.userDoestSpeakTestLanguage;
    case 'unappealingUI':
      return FeedbackOptions.unappealingUI;
    case 'unappealingContent':
      return FeedbackOptions.unappealingContent;
    case 'deviceNotSupported':
      return FeedbackOptions.deviceNotSupported;
    case 'conceptNotUnderstood':
      return FeedbackOptions.conceptNotUnderstood;
    case 'appInTooBetaStage':
      return FeedbackOptions.appInTooBetaStage;
    case 'other':
      return FeedbackOptions.other;

    default:
      throw Exception('Invalid feedback option');
  }
}

AppCategory getAppCategoryFromString(String category) {
  switch (category) {
    case 'books':
      return AppCategory.books;
    case 'business':
      return AppCategory.business;
    case 'education':
      return AppCategory.education;
    case 'entertainment':
      return AppCategory.entertainment;
    case 'finance':
      return AppCategory.finance;
    case 'foodAndDrink':
      return AppCategory.foodAndDrink;
    case 'games':
      return AppCategory.games;
    case 'healthAndFitness':
      return AppCategory.healthAndFitness;
    case 'lifestyle':
      return AppCategory.lifestyle;
    case 'medical':
      return AppCategory.medical;
    case 'music':
      return AppCategory.music;
    case 'news':
      return AppCategory.news;
    case 'photoAndVideo':
      return AppCategory.photoAndVideo;
    case 'productivity':
      return AppCategory.productivity;
    case 'reference':
      return AppCategory.reference;
    case 'shopping':
      return AppCategory.shopping;
    case 'socialNetworking':
      return AppCategory.socialNetworking;
    case 'sports':
      return AppCategory.sports;
    case 'travel':
      return AppCategory.travel;
    case 'utilities':
      return AppCategory.utilities;
    case 'weather':
      return AppCategory.weather;

    default:
      throw Exception('Invalid category');
  }
}
