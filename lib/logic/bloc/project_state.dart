part of 'project_bloc.dart';

sealed class ProjectState {
  Project? project;

  ProjectState({required this.project});
}

final class ProjectInitialState extends ProjectState {
  ProjectInitialState({required super.project});
}

final class SavingProjectState extends ProjectState {
  SavingProjectState({required super.project});
}

final class ProjectSavedState extends ProjectState {
  ProjectSavedState({required super.project});
}

final class ErrorSavingProjectSate extends ProjectState {
  ErrorSavingProjectSate({required super.project});
}
