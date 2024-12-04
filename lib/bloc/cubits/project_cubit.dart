import 'dart:developer';

import 'package:bloc/bloc.dart';
import '../../data/models/projects.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectState(project: null));

  void updateProject(Project project) => emit(ProjectState(project: project));

  @override
  void onChange(Change<ProjectState> change) {
    log('current project state :${change.currentState.project} => next project state :${change.nextState.project}');
    super.onChange(change);
  }
}
