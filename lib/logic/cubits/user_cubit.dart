import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/constants.dart';
import '../../data/models/users.dart';

part 'user_state.dart';

class MimUserCubit extends Cubit<MimUserState> {
  MimUserCubit() : super(MimUserState(user: null));

  void updateUser(MimUser user) => emit(MimUserState(user: user));

  @override
  void onChange(Change<MimUserState> change) {
    // TODO: implement onChange
    log('current user state :${change.currentState.user} => next user state :${change.nextState.user}');

    super.onChange(change);
  }


}
