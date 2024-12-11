part of 'project_operations_bloc.dart';

sealed class ProjectOperationsState {
  Project? project;

  ProjectOperationsState({required this.project});
}

final class ProjectOperationsInitial extends ProjectOperationsState {
  ProjectOperationsInitial() : super(project: null);
}

final class ProjectOperationStarted extends ProjectOperationsState {
  ProjectOperationStarted({required super.project}) {
    assert(project != null);
  }
}

final class ProjectCreated extends ProjectOperationsState {
  ProjectCreated({required super.project}) {
    assert(project != null);
  }
}

final class ProjectLoaded extends ProjectOperationsState {
  ProjectLoaded({required super.project}) {
    assert(project != null);
  }
}

final class ProjectUpdated extends ProjectOperationsState {
  ProjectUpdated({required super.project}) {
    assert(project != null);
  }
}

final class ProjectDeleted extends ProjectOperationsState {
  ProjectDeleted({required super.project});
}

final class ProjectOperationsError extends ProjectOperationsState {
  final ProjectErrors error;

  ProjectOperationsError({required this.error}) : super(project: null);
}
