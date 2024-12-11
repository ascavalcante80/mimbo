part of 'user_loader_bloc.dart';

@immutable
sealed class UserLoaderEvent {}

class GetUserEvent extends UserLoaderEvent {
  final String userId;

  GetUserEvent({required this.userId});
}
