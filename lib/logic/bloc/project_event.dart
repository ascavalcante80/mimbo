part of 'project_bloc.dart';

sealed class ProjectEvent {
  Project? project;

  ProjectEvent({required this.project});
}

class SaveProjectButtonPressed extends ProjectEvent {
  SaveProjectButtonPressed({required super.project});
}

class SaveChangesButtonPressed extends ProjectEvent {
  SaveChangesButtonPressed({required super.project});
}

class SavingProjectEvent extends ProjectEvent {
  SavingProjectEvent({required super.project});
}

class ProjectSavedEvent extends ProjectEvent {
  ProjectSavedEvent({required super.project});
}

class ErrorSavingProjectEvent extends ProjectEvent {
  ErrorSavingProjectEvent({required super.project});
}
