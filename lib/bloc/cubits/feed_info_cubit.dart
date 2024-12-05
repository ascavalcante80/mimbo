import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/feed_info.dart';

part 'feed_info_state.dart';

class FeedInfoCubit extends Cubit<FeedInfoState> {
  FeedInfoCubit()
      : super(FeedInfoState(
            feedInfo: null));

  void updateFeedInfo(FeedInfo feedInfo) =>
      emit(FeedInfoState(feedInfo: feedInfo));

  void appendTestLIst(String testId) {
    state.feedInfo!.testsIdsSeen.add(testId);
    emit(FeedInfoState(feedInfo: state.feedInfo));
  }

  void startedTest(String testId) {
    state.feedInfo!.testInProgressId = testId;
    emit(FeedInfoState(feedInfo: state.feedInfo));
  }
}
