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
