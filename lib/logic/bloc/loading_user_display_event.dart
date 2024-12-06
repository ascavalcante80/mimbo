part of 'loading_user_display_bloc.dart';

@immutable
sealed class LoadUserDisplayEvent {}

final class LoadingUserStartedEvent extends LoadUserDisplayEvent {}

final class UserNotFoundEvent extends LoadUserDisplayEvent {}

final class LoadingProjectsEvent extends LoadUserDisplayEvent {}

final class LoadingCompleteEvent extends LoadUserDisplayEvent {}

final class ErrorLoadingUserEvent extends LoadUserDisplayEvent {}
