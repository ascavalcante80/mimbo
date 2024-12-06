part of 'loading_user_display_bloc.dart';

@immutable
sealed class LoadUserState {}

final class InitialState extends LoadUserState {}

final class LoadingUserState extends LoadUserState {}

final class UserNotFoundState extends LoadUserState {}

final class LoadingProjectsState extends LoadUserState {}

final class ErrorLoadingUserState extends LoadUserState {}

final class ErrorLoadingProjectsState extends LoadUserState {}

final class LoadingCompleteState extends LoadUserState {}
