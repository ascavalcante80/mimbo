import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mimbo/bloc/cubits/project_cubit.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/models/projects.dart';

// import 'package:gnomee/constants/enums.dart';
// import 'package:gnomee/data/models/user.dart';
// import 'package:gnomee/data/repositories/firebase_manager.dart';
// import 'package:gnomee/data/repositories/user_manager.dart';
// import 'package:gnomee/utils/date_tools.dart';
import 'package:mimbo/data/models/users.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';
import 'package:mimbo/data/repositories/project_manager.dart';
import 'package:mimbo/data/repositories/user_manager.dart';

void main() {
  group('project manager Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreManager firestoreManager;
    String userId = 'testUserId';
    Project createdProject;
    setUp(() {
      // Initialize FakeFirestore
      fakeFirestore = FakeFirebaseFirestore();
      firestoreManager =
          FirestoreManager(userId: userId, firestore: fakeFirestore);
    });

    test('Create project on Firestore using project manager', () async {
      Project project = Project(
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

      ProjectManager projectManager =
          ProjectManager(userId: userId, firestoreManager: firestoreManager);

      createdProject = await projectManager.createProject(
        project.name,
        project.description,
        project.category,
        project.officialUrl,
        project.installationUrls,
        project.keywords,
        project.languages,
        project.screenshotsPics,
        project.unreadAnswersIds,
        project.feedbackAssessmentIds,
      );

      expect(createdProject, project,
          reason: 'User must be the same as the one created');
    });

    testWidgets('Test function using BuildContext',
        (WidgetTester tester) async {
      Project project = Project(
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

      ProjectManager projectManager =
          ProjectManager(userId: userId, firestoreManager: firestoreManager);

      createdProject = await projectManager.createProject(
        project.name,
        project.description,
        project.category,
        project.officialUrl,
        project.installationUrls,
        project.keywords,
        project.languages,
        project.screenshotsPics,
        project.unreadAnswersIds,
        project.feedbackAssessmentIds,
      );

      // Define a test widget
      final testWidget = BlocProvider(
        create: (context) => ProjectCubit(),
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                // Your function call here

                ProjectManager projectManager = ProjectManager(
                    userId: userId, firestoreManager: firestoreManager);
                projectManager.loadProject(createdProject.id, context);

                return Container();
              },
            ),
          ),
        ),
      );
    });
  });
}
