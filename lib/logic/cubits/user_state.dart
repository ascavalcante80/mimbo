part of 'user_cubit.dart';

sealed class UserState {
  MimUser? user;

  UserState({required this.user});
}

final class UserInitial extends UserState {
  UserInitial() : super(user: null);
}

final class UserLoading extends UserState {
  UserLoading() : super(user: null);
}

final class UserLoaded extends UserState {
  UserLoaded({required super.user}) {
    assert(user != null);
  }
}

final class UserUpdate extends UserState {
  UserUpdate({required super.user}) {
    assert(user != null);
  }
}
