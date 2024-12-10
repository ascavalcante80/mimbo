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

final class ProjectCreatedState extends ProjectState {
  ProjectCreatedState({required super.project});
}

final class ErrorSavingProjectSate extends ProjectState {
  ProjectError errorType;

  ErrorSavingProjectSate({required super.project, required this.errorType});
}

final class ErrorDeletingProjectState extends ProjectState {
  ProjectError errorType;

  ErrorDeletingProjectState({
    required super.project,
    required this.errorType,
  });
}

final class ProjectLoadedState extends ProjectState {
  ProjectLoadedState({required super.project});
}

final class ProjectUpdatedState extends ProjectState {
  ProjectUpdatedState({required super.project});
}

final class DeletingProjectState extends ProjectState {
  DeletingProjectState({required super.project});
}

final class ProjectDeletedState extends ProjectState {
  ProjectDeletedState({required super.project});
}