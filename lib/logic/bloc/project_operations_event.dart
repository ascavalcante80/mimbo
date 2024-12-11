part of 'project_operations_bloc.dart';

@immutable
sealed class ProjectOperationsEvent {}

final class SaveChangesButtonPressed extends ProjectOperationsEvent {
  final Project project;

  SaveChangesButtonPressed({required this.project});
}

final class CreateProjectButtonPressed extends ProjectOperationsEvent {
  final Project project;

  CreateProjectButtonPressed({required this.project});
}

final class DeleteProjectButtonPressed extends ProjectOperationsEvent {
  final Project project;

  DeleteProjectButtonPressed({required this.project});
}
