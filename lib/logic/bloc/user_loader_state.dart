part of 'user_loader_bloc.dart';

sealed class UserLoaderState {
  MimUser? mimUser;
  Project? project;

  UserLoaderState({required this.mimUser, required this.project});
}

final class UserLoaderInitial extends UserLoaderState {
  UserLoaderInitial() : super(mimUser: null, project: null);
}

final class LoadingUserState extends UserLoaderState {
  LoadingUserState() : super(mimUser: null, project: null);
}

final class UserLoadedState extends UserLoaderState {
  UserLoadedState({required super.mimUser}) : super(project: null) {
    assert(mimUser != null);
  }
}

final class ErrorLoadingUserState extends UserLoaderState {
  final LoaderErrorType errorType;

  ErrorLoadingUserState({required this.errorType})
      : super(mimUser: null, project: null);
}

final class LoadingProjectState extends UserLoaderState {
  LoadingProjectState({required super.mimUser, required super.project});
}

final class UsersProjectLoadedState extends UserLoaderState {
  UsersProjectLoadedState({required super.mimUser, required super.project}) {
    assert(project != null);
    assert(mimUser != null);
  }
}

final class ErrorLoadingProjectState extends UserLoaderState {
  final LoaderErrorType errorType;

  ErrorLoadingProjectState({required this.errorType})
      : super(mimUser: null, project: null);
}

final class LoadingCompleteState extends UserLoaderState {
  LoadingCompleteState({required super.mimUser, required super.project}) {
    assert(mimUser != null);
  }
}
