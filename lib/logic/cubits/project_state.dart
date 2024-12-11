part of 'project_cubit.dart';

sealed class ProjectState {
  final Project? project;

  ProjectState({this.project});
}

final class ProjectInitial extends ProjectState {
  ProjectInitial() : super(project: null);
}

final class ProjectLoadedState extends ProjectState {
  ProjectLoadedState({required super.project}) {
    assert(project != null);
  }
}

final class ProjectUpdateState extends ProjectState {
  ProjectUpdateState({required super.project}) {
    assert(project != null);
  }
}

final class ProjectDeleteState extends ProjectState {
  ProjectDeleteState() : super(project: null);
}
