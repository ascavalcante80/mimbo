import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/models/users.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';
import 'package:mimbo/logic/cubits/user_cubit.dart';

import '../../data/models/projects.dart';

part 'project_operations_event.dart';

part 'project_operations_state.dart';

class ProjectOperationsBloc
    extends Bloc<ProjectOperationsEvent, ProjectOperationsState> {
  FirestoreManager firestoreManager = FirestoreManager(
    firestore: FirebaseFirestore.instance,
    userId: FirebaseAuth.instance.currentUser!.uid,
  );

  ProjectOperationsBloc() : super(ProjectOperationsInitial()) {
    on<ProjectOperationsEvent>(mapEventToState);
  }

  void mapEventToState(ProjectOperationsEvent event,
      Emitter<ProjectOperationsState> emit) async {
    if (event is CreateProjectButtonPressed) {
      await createProject(event.project, emit);
    } else if (event is SaveChangesButtonPressed) {
      await updateProject(event.project, emit);
    } else if (event is DeleteProjectButtonPressed) {
      await deleteProject(event.project, emit);
    }
  }

  Future<void> createProject(
      Project project, Emitter<ProjectOperationsState> emit) async {
    try {
      emit(ProjectOperationStarted(project: project));
      String? id = await firestoreManager.createProject(project);
      if (id != null) {
        Project? projectCreated = project.copyWithUpdateId(id);
        MimUser? user = await firestoreManager.getUserByID(project.ownerId);
        user!.projectIds.add(id);
        firestoreManager.updateUser(user);
        emit(ProjectCreated(project: projectCreated));
      } else {
        emit(ProjectOperationsError(error: ProjectErrors.firestoreError));
      }
    } catch (e) {
      log('error: $e');
      emit(ProjectOperationsError(error: ProjectErrors.firestoreError));
    }
  }

  Future<void> updateProject(
      Project project, Emitter<ProjectOperationsState> emit) async {
    emit(ProjectOperationStarted(project: project));
    try {
      await firestoreManager.updateProject(project);
      emit(ProjectUpdated(project: project));
    } catch (e) {
      emit(ProjectOperationsError(error: ProjectErrors.firestoreError));
    }
  }

  Future<void> deleteProject(
      Project project, Emitter<ProjectOperationsState> emit) async {
    emit(ProjectOperationStarted(project: project));
    try {
      await firestoreManager.deleteProject(project.id);
      MimUser? user = await firestoreManager.getUserByID(project.ownerId);
      user!.projectIds.remove(project.id);
      await firestoreManager.updateUser(user);
      emit(ProjectDeleted(project: project));
    } catch (e) {
      emit(ProjectOperationsError(error: ProjectErrors.firestoreError));
    }
  }
}
