import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';
import 'package:mimbo/data/repositories/project_manager.dart';
import 'package:mimbo/logic/cubits/project_cubit.dart';

import '../../data/models/projects.dart';

part 'project_event.dart';

part 'project_state.dart';

class ProjectButtonBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectButtonBloc() : super(ProjectInitialState(project: null)) {
    on<ProjectEvent>(mapEventToState);
  }

  void mapEventToState(ProjectEvent event, Emitter<ProjectState> emit) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirestoreManager firestoreManager =
        FirestoreManager(userId: userId, firestore: FirebaseFirestore.instance);

    if (event is SaveProjectButtonPressed) {
      emit(SavingProjectState(project: null));
      try {
        String? projectId =
            await firestoreManager.createProject(event.project!);
        if (projectId == null) {
          emit(ErrorSavingProjectSate(
              project: null, errorType: ProjectError.firestoreError));
          return;
        }
        Project savedProject = event.project!.copyWithUpdateId(projectId);
        emit(ProjectCreatedState(project: savedProject));
      } catch (e) {
        emit(ErrorSavingProjectSate(
            project: null, errorType: ProjectError.firestoreError));
      }
    } else if (event is SaveChangesButtonPressed) {
      emit(SavingProjectState(project: null));
      try {
        await firestoreManager.updateProject(event.project!);
        emit(ProjectUpdatedState(project: event.project!));
      } catch (e) {
        emit(ErrorSavingProjectSate(
            project: null, errorType: ProjectError.firestoreError));
      }
    }
  }
}
