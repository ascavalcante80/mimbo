import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mimbo/bloc/cubits/project_cubit.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/models/credits.dart';
import 'package:mimbo/data/models/feedback_form.dart';
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

    setUp(() {
      // Initialize FakeFirestore
      fakeFirestore = FakeFirebaseFirestore();
      firestoreManager =
          FirestoreManager(userId: userId, firestore: fakeFirestore);
    });

    test('Test CRUD operations for MimUser', () async {
      FirestoreManager firestoreManager = FirestoreManager(
        userId: userId,
        firestore: fakeFirestore,
      );

      MimUser userMatcher = MimUser(
        id: userId,
        username: 'username',
        name: 'name',
        createdAt: DateTime.now(),
        birthdate: DateTime.now(),
        gender: UserGender.notBinary,
        projectIds: [],
      );

      await firestoreManager.createUser(userMatcher);
      MimUser? userResponse = await firestoreManager.getUserByID(userId);

      expect(userResponse, userMatcher,
          reason: 'User must be the same as the one created');

      MimUser userUpdated = MimUser(
        id: userResponse!.id,
        username: 'usernameUpdated',
        name: userResponse.name,
        createdAt: userResponse.createdAt,
        birthdate: userResponse.birthdate,
        gender: userResponse.gender,
        projectIds: userResponse.projectIds,
      );
      await firestoreManager.updateUser(userUpdated);

      MimUser? updatedUserResponse = await firestoreManager.getUserByID(userId);
      expect(userUpdated, updatedUserResponse,
          reason: 'User must be the same as the one updated');

      MimUser userUpdatedSameUsername = MimUser(
        id: 'id2',
        username: 'usernameUpdated',
        name: userResponse.name,
        createdAt: userResponse.createdAt,
        birthdate: userResponse.birthdate,
        gender: userResponse.gender,
        projectIds: userResponse.projectIds,
      );
      bool inserted;
      try {
        await firestoreManager.createUser(userUpdatedSameUsername);
        inserted = true;
      } on UsernameAlreadyExistsException {
        inserted = false;
      }
      expect(inserted, false, reason: 'Username must be unique');
    });

    test('Test CRUD operations for Project', () async {
      Project project = Project(
        id: 'mockId',
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

      String? id = await firestoreManager.createProject(project);
      expect(id, isNotNull, reason: 'Project id must not be null');

      Project createdProject = Project(
        id: id!,
        ownerId: project.ownerId,
        name: project.name,
        description: project.description,
        category: project.category,
        createdAt: project.createdAt,
        officialUrl: project.officialUrl,
        installationUrls: project.installationUrls,
        keywords: project.keywords,
        languages: project.languages,
        screenshotsPics: project.screenshotsPics,
        unreadAnswersIds: project.unreadAnswersIds,
        feedbackAssessmentIds: project.feedbackAssessmentIds,
      );
      Project? fetchedProject = await firestoreManager.getProjectByID(id);

      expect(fetchedProject, createdProject,
          reason: 'Project must be the same as the one created');

      Project updatedProject = Project(
        id: fetchedProject!.id,
        ownerId: project.ownerId,
        name: project.name,
        description: 'Description Updated',
        category: project.category,
        createdAt: project.createdAt,
        officialUrl: project.officialUrl,
        installationUrls: project.installationUrls,
        keywords: project.keywords,
        languages: project.languages,
        screenshotsPics: project.screenshotsPics,
        unreadAnswersIds: project.unreadAnswersIds,
        feedbackAssessmentIds: project.feedbackAssessmentIds,
      );

      await firestoreManager.updateProject(updatedProject);

      Project? fetchedUpdatedProject =
          await firestoreManager.getProjectByID(id);
      expect(fetchedUpdatedProject, updatedProject,
          reason: 'Project must be the same as the one updated');

      firestoreManager.deleteProject(fetchedUpdatedProject!.id);

      Project? fetchedDeletedProject =
          await firestoreManager.getProjectByID(id);

      expect(fetchedDeletedProject, isNull, reason: 'Project must be null');
    });

    test('Test CRUD operations for MimCredit', () async {
      MimCredit credit = MimCredit(
        id: 'id',
        createdAt: DateTime.now(),
        attributedToTestId: '',
        consumedAt: DateTime.now(),
        consumedWithAnswerId: 'mockId',
        earnedWithTestId: 'mockId',
        earnedByUserId: 'mockUserId',
      );

      String? id = await firestoreManager.createCredit(credit);
      expect(id, isNotNull, reason: 'Credit id must not be null');

      MimCredit createdCredit = MimCredit(
        id: id!,
        createdAt: DateTime.now(),
        attributedToTestId: '',
        consumedAt: DateTime.now(),
        consumedWithAnswerId: 'mockId',
        earnedWithTestId: 'mockId',
        earnedByUserId: 'mockUserId',
      );

      createdCredit.consumedAt = DateTime.now();
      await firestoreManager.updateCredit(createdCredit);

      MimCredit? fetchedCredit =
          await firestoreManager.getCreditByID(createdCredit.id);
      expect(fetchedCredit, createdCredit,
          reason: 'Credit must be the same as the one created');
    });

    test('Test CRUD operations for FormFeedback', () async {
      bool assertThrows = false;
      try {
        FormFeedback(
          id: '',
          createdAt: DateTime.now(),
          projectId: 'mockId',
          userId: 'mockUserId',
          openTestId: 'toMockId',
          openFeedback: '',
          feedbackOption: FeedbackOptions.appInTooBetaStage,
        );
      } catch (e) {
        assertThrows = true;
      }

      expect(assertThrows, true, reason: 'FormFeedback id must not be empty');

      try {
        FormFeedback(
          id: 'id',
          createdAt: DateTime.now(),
          projectId: '   ',
          userId: 'mockUserId',
          openTestId: 'toMockId',
          openFeedback: '',
          feedbackOption: FeedbackOptions.appInTooBetaStage,
        );
      } catch (e) {
        assertThrows = true;
      }

      expect(assertThrows, true,
          reason: 'FormFeedback Project ID must not be empty');

      try {
        FormFeedback(
          id: 'id',
          createdAt: DateTime.now(),
          projectId: 'fa',
          userId: '',
          openTestId: 'toMockId',
          openFeedback: '',
          feedbackOption: FeedbackOptions.appInTooBetaStage,
        );
      } catch (e) {
        assertThrows = true;
      }

      expect(assertThrows, true,
          reason: 'FormFeedback user ID must not be empty');

      try {
        FormFeedback(
          id: 'id',
          createdAt: DateTime.now(),
          projectId: 'projectId',
          userId: 'mockUserId',
          openTestId: ' ',
          openFeedback: '',
          feedbackOption: FeedbackOptions.appInTooBetaStage,
        );
      } catch (e) {
        assertThrows = true;
      }

      expect(assertThrows, true,
          reason: 'FormFeedback open test ID must not be empty');

      DateTime now = DateTime.now();
      FormFeedback formFeedback = FormFeedback(
        id: 'id',
        createdAt: now,
        projectId: 'mockId',
        userId: 'mockUserId',
        openTestId: 'toMockId',
        openFeedback: '',
        feedbackOption: FeedbackOptions.appInTooBetaStage,
      );

      String? id = await firestoreManager.createFormFeedback(formFeedback);
      expect(id, isNotNull, reason: 'FormFeedback id must not be null');

      FormFeedback createdFormFeedback = FormFeedback(
        id: id!,
        createdAt: formFeedback.createdAt,
        projectId: formFeedback.projectId,
        userId: formFeedback.userId,
        openTestId: formFeedback.openTestId,
        openFeedback: formFeedback.openFeedback,
        feedbackOption: FeedbackOptions.appInTooBetaStage,
      );

      FormFeedback? fetchedFormFeedback =
          await firestoreManager.getFormFeedbackByID(
        createdFormFeedback.projectId,
        createdFormFeedback.id,
      );
      expect(fetchedFormFeedback, createdFormFeedback,
          reason: 'FormFeedback must be the same as the one created');
    });

    test('Fetch whole collections of Feedbacks', () async {
      List<FormFeedback> formFeedbacks = [];
      for (int i = 0; i < 10; i++) {
        FormFeedback formFeedback = FormFeedback(
          id: 'id$i',
          createdAt: DateTime.now(),
          projectId: 'mockId',
          userId: 'mockUserId',
          openTestId: 'toMockId',
          openFeedback: '',
          feedbackOption: FeedbackOptions.appInTooBetaStage,
        );
        String? id = await firestoreManager.createFormFeedback(formFeedback);

        FormFeedback createdFormFeedback = FormFeedback(
          id: id!,
          createdAt: formFeedback.createdAt,
          projectId: formFeedback.projectId,
          userId: formFeedback.userId,
          openTestId: formFeedback.openTestId,
          openFeedback: formFeedback.openFeedback,
          feedbackOption: FeedbackOptions.appInTooBetaStage,
        );

        formFeedbacks.add(createdFormFeedback);
      }

      List<FormFeedback> fetchedFormFeedbacks =
          await firestoreManager.getFormFeedbacksByProjectID('mockId');

      expect(fetchedFormFeedbacks, formFeedbacks,
          reason: 'FormFeedbacks must be the same as the ones created');
    });
  });
}
