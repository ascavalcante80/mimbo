import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../../data/models/projects.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectInitial());

  void updateProject(Project project) =>
      emit(ProjectUpdateState(project: project));

  void loadProject(Project project) =>
      emit(ProjectLoadedState(project: project));

  void deleteProject(Project project) => emit(ProjectDeleteState());

  @override
  void onChange(Change<ProjectState> change) {
    log('current project state :${change.currentState.project} => next project state :${change.nextState.project}');
    super.onChange(change);
  }
}
