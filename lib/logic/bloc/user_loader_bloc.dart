import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:mimbo/data/models/projects.dart';
import 'package:mimbo/data/models/users.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';

import '../../data/constants.dart';

part 'user_loader_event.dart';

part 'user_loader_state.dart';

class UserLoaderBloc extends Bloc<UserLoaderEvent, UserLoaderState> {
  FirestoreManager firestoreManager = FirestoreManager(
      userId: FirebaseAuth.instance.currentUser!.uid,
      firestore: FirebaseFirestore.instance);

  UserLoaderBloc() : super(UserLoaderInitial()) {
    on<UserLoaderEvent>(mapEventToState);
  }

  void mapEventToState(
      UserLoaderEvent event, Emitter<UserLoaderState> emit) async {
    MimUser? mimUser;
    if (event is GetUserEvent) {
      mimUser = await loadUser(event.userId, emit);

      if (mimUser == null) {
        return;
      } else {
        if (mimUser.projectIds.isNotEmpty) {
          await loadProject(mimUser.projectIds[0], mimUser, emit);
        } else {
          emit(LoadingCompleteState(mimUser: mimUser, project: null));
        }
      }
    }
  }

  Future<Project?> loadProject(
      String projectId, MimUser mimUser, Emitter<UserLoaderState> emit) async {
    Project? project;
    emit(LoadingProjectState(mimUser: mimUser, project: null));
    try {
      project = await firestoreManager.getProjectByID(projectId);

      if (project == null) {
        emit(ErrorLoadingProjectState(
            errorType: LoaderErrorType.projectNotFound));
        return project;
      }
    } on ProjectNotFoundException {
      emit(
          ErrorLoadingProjectState(errorType: LoaderErrorType.projectNotFound));
      return project;
    }
    emit(UsersProjectLoadedState(mimUser: mimUser, project: project));
    emit(LoadingCompleteState(mimUser: mimUser, project: project));
    return project;
  }

  Future<MimUser?> loadUser(
      String userId, Emitter<UserLoaderState> emit) async {
    MimUser? mimUser;
    emit(LoadingUserState());
    try {
      mimUser = await firestoreManager.getUserByID(userId);
    } on UserNotFoundException {
      emit(ErrorLoadingUserState(errorType: LoaderErrorType.userNotFound));
    } catch (e) {
      emit(ErrorLoadingUserState(errorType: LoaderErrorType.errorLoadingUser));
    }

    if (mimUser == null) {
      emit(ErrorLoadingUserState(errorType: LoaderErrorType.errorLoadingUser));
    } else {
      emit(UserLoadedState(mimUser: mimUser));
    }
    return mimUser;
  }
}
