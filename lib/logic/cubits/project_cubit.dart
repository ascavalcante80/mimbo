import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:mimbo/logic/bloc/project_bloc.dart';
import '../../data/models/projects.dart';

// part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectInitialState(project: null));

  void updateProject(Project project) => emit(ProjectLoadedState(project: project));

  @override
  void onChange(Change<ProjectState> change) {
    log('current project state :${change.currentState.project} => next project state :${change.nextState.project}');
    super.onChange(change);
  }
}
