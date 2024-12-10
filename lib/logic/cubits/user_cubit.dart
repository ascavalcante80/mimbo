import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mimbo/logic/bloc/user_bloc.dart';

import '../../data/constants.dart';
import '../../data/models/users.dart';

class MimUserCubit extends Cubit<UserState> {
  MimUserCubit() : super(UserInitialState());

  void updateUser(MimUser user) => emit(UserUpdatedState(user: user));

  @override
  void onChange(Change<UserState> change) {
    // TODO: implement onChange
    log('current user state :${change.currentState.user} => next user state :${change.nextState.user}');

    super.onChange(change);
  }
}
