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
    case 'AppCategory.books':
      return AppCategory.books;
    case 'AppCategory.business':
      return AppCategory.business;
    case 'AppCategory.education':
      return AppCategory.education;
    case 'AppCategory.entertainment':
      return AppCategory.entertainment;
    case 'AppCategory.finance':
      return AppCategory.finance;
    case 'AppCategory.foodAndDrink':
      return AppCategory.foodAndDrink;
    case 'AppCategory.games':
      return AppCategory.games;
    case 'AppCategory.healthAndFitness':
      return AppCategory.healthAndFitness;
    case 'AppCategory.lifestyle':
      return AppCategory.lifestyle;
    case 'AppCategory.medical':
      return AppCategory.medical;
    case 'AppCategory.music':
      return AppCategory.music;
    case 'AppCategory.news':
      return AppCategory.news;
    case 'AppCategory.photoAndVideo':
      return AppCategory.photoAndVideo;
    case 'AppCategory.productivity':
      return AppCategory.productivity;
    case 'AppCategory.reference':
      return AppCategory.reference;
    case 'AppCategory.shopping':
      return AppCategory.shopping;
    case 'AppCategory.socialNetworking':
      return AppCategory.socialNetworking;
    case 'AppCategory.sports':
      return AppCategory.sports;
    case 'AppCategory.travel':
      return AppCategory.travel;
    case 'AppCategory.utilities':
      return AppCategory.utilities;
    case 'AppCategory.weather':
      return AppCategory.weather;

    default:
      throw Exception('Invalid category');
  }
}
