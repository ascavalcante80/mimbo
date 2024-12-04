class FeedInfo {
  final String id;
  final String ownerId;
  DateTime dateCursor;
  List<String> testsIdsSeen;
  String? testInProgressId;

  FeedInfo({
    required this.id,
    required this.ownerId,
    required this.dateCursor,
    required this.testsIdsSeen,
    required this.testInProgressId,
  });
}
