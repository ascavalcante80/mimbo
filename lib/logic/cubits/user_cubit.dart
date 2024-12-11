import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/constants.dart';
import '../../data/models/users.dart';

part 'user_state.dart';

class MimUserCubit extends Cubit<UserState> {
  MimUserCubit() : super(UserInitial());

  void loadUser(MimUser user) => emit(UserLoaded(user: user));

  @override
  void onChange(Change<UserState> change) {
    // TODO: implement onChange
    log('current user state :${change.currentState.user} => next user state :${change.nextState.user}');
    super.onChange(change);
  }

  void addUserProject(String projectId) {
    MimUser? user = state.user;
    if (user != null) {
      user.projectIds.add(projectId);
      log('User project added : $projectId');
      emit(UserUpdate(user: user));
    }
  }

  void removeUserProject(String projectId) {
    MimUser? user = state.user;
    if (user != null) {
      user.projectIds.remove(projectId);
      log('User project removed : $projectId');
      emit(UserUpdate(user: user));
    }
  }
}
