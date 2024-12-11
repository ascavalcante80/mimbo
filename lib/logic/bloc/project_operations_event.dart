part of 'project_operations_bloc.dart';

sealed class ProjectOperationsEvent {}

final class SaveChangesButtonPressed extends ProjectOperationsEvent {
  final Project project;

  SaveChangesButtonPressed({required this.project});
}

final class CreateProjectButtonPressed extends ProjectOperationsEvent {
  Project project;

  CreateProjectButtonPressed({required this.project});
}

final class EditProjectButtonPressed extends ProjectOperationsEvent {
  final Project project;

  EditProjectButtonPressed({required this.project});
}

final class DeleteProjectButtonPressed extends ProjectOperationsEvent {
  final Project project;

  DeleteProjectButtonPressed({required this.project});
}

final class ProjectHasBeenLoaded extends ProjectOperationsEvent {
  final Project project;

  ProjectHasBeenLoaded({required this.project});
}
