import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/project_cubit.dart';
import '../models/projects.dart';
import 'firebase_manager.dart';

class ProjectManager {
  String userId;
  FirestoreManager firestoreManager;

  ProjectManager({required this.userId, required this.firestoreManager});

  void loadProject(String projectId, BuildContext context) async {
    /// fetches the project from the Firestore database and loads it to Cubit.
    /// Throws an error if the project does not exist.

    try {
      // fetch project from Firestore
      Project? project = await firestoreManager.getProjectByID(projectId);

      // load mock project
      if (!context.mounted) {
        return;
      }

      if (project != null) {
        BlocProvider.of<ProjectCubit>(context).updateProject(project);
      }
    } catch (e) {
      return;
    }
  }

  Future<Project> createProject(
    String name,
    String description,
    String category,
    String officialUrl,
    Map<String, String> installationUrls,
    List<String> keywords,
    List<String> languages,
    List<String> screenshotsPics,
    List<String> unreadAnswersIds,
    List<String> feedbackAssessmentIds,
  ) async {
    return Project(
      id: '1',
      ownerId: '1',
      name: name,
      description: 'This is a mock project',
      category: 'Mock Category',
      createdAt: DateTime.now(),
      officialUrl: 'https://mockproject.com',
      installationUrls: {'mock': 'https://mockproject.com'},
      keywords: ['mock', 'project'],
      languages: ['mock'],
      screenshotsPics: ['mock'],
      unreadAnswersIds: ['mock'],
      feedbackAssessmentIds: ['mock'],
    );
  }
}
