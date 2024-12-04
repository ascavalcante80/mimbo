import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubits/project_cubit.dart';
import '../models/projects.dart';

class ProjectManager {
  void loadProject(String projectId, BuildContext context) async {
    /// fetches the project from the Firestore database and loads it to Cubit.
    /// Throws an error if the project does not exist.

    // load mock project
    Project mockProject = Project(
      id: '1',
      ownerId: '1',
      name: 'Mock Project',
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
    BlocProvider.of<ProjectCubit>(context).updateProject(mockProject);
  }
}
