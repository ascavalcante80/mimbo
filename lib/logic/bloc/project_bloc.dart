import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/models/users.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';
import 'package:mimbo/data/repositories/project_manager.dart';
import 'package:mimbo/logic/cubits/project_cubit.dart';

import '../../data/models/projects.dart';

part 'project_event.dart';

part 'project_state.dart';

class ProjectButtonBloc extends Bloc<ProjectEvent, ProjectState> {
  final FirestoreManager firestoreManager = FirestoreManager(
      userId: FirebaseAuth.instance.currentUser!.uid,
      firestore: FirebaseFirestore.instance);

  ProjectButtonBloc() : super(ProjectInitialState(project: null)) {
    on<ProjectEvent>(mapEventToState);
  }

  void mapEventToState(ProjectEvent event, Emitter<ProjectState> emit) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirestoreManager firestoreManager =
        FirestoreManager(userId: userId, firestore: FirebaseFirestore.instance);

    if (event is SaveProjectButtonPressed) {
      createProject(event.project!, emit);
    } else if (event is SaveChangesButtonPressed) {
      saveChanges(event.project!, emit);
    } else if (event is DeleteProjectButtonPressed) {
      deleteProject(event.project!, emit);
    }
  }

  void createProject(Project project, Emitter<ProjectState> emit) async {
    emit(SavingProjectState(project: null));
    try {
      String? projectId = await firestoreManager.createProject(project);

      if (projectId == null) {
        emit(ErrorSavingProjectSate(
            project: null, errorType: ProjectError.firestoreError));
        return;
      }

      MimUser? user = await firestoreManager.getUserByID(project.ownerId);
      if (user == null) {
        emit(ErrorSavingProjectSate(
            project: null, errorType: ProjectError.projectOwnerNotFound));
        return;
      } else {
        user.projectIds.add(projectId);
        await firestoreManager.updateUser(user);
      }

      Project savedProject = project.copyWithUpdateId(projectId);
      // update profile with project id
      emit(ProjectCreatedState(project: savedProject));
    } catch (e) {
      emit(ErrorSavingProjectSate(
          project: null, errorType: ProjectError.firestoreError));
    }
  }

  void saveChanges(Project project, Emitter<ProjectState> emit) async {
    emit(SavingProjectState(project: null));
    try {
      await firestoreManager.updateProject(project);
      emit(ProjectUpdatedState(project: project));
    } catch (e) {
      emit(ErrorSavingProjectSate(
          project: null, errorType: ProjectError.firestoreError));
    }
  }

  void deleteProject(Project project, Emitter<ProjectState> emit) async {
    emit(DeletingProjectState(project: null));
    try {
      await firestoreManager.deleteProject(project.id);
      emit(ProjectDeletedState(project: null));
    } catch (e) {
      emit(ErrorDeletingProjectState(
          project: null, errorType: ProjectError.firestoreError));
    }
  }
}
