// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mimbo/data/constants.dart';

// import 'package:gnomee/constants/enums.dart';
// import 'package:gnomee/data/models/user.dart';
// import 'package:gnomee/data/repositories/firebase_manager.dart';
// import 'package:gnomee/data/repositories/user_manager.dart';
// import 'package:gnomee/utils/date_tools.dart';
import 'package:mimbo/data/models/users.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';
import 'package:mimbo/data/repositories/user_manager.dart';

void main() {
  group('FirestoreManager Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreManager firestoreManager;
    String userId = 'testUserId';

    setUp(() {
      // Initialize FakeFirestore
      fakeFirestore = FakeFirebaseFirestore();
      firestoreManager =
          FirestoreManager(userId: userId, firestore: fakeFirestore);
    });

    test('Create User', () async {
      DateTime createdAt = DateTime.now();
      List<String> projectsIds = [];

      String newUserId = 'newUserId';
      UserManager userManagerTest = UserManager(
        userId: newUserId,
        firestoreManager: firestoreManager,
      );

      String username = 'new.username';
      DateTime birthdate = DateTime(2000, 1, 1);
      UserGender userGender = UserGender.notBinary;
      String name = 'new name';

      MimUser userMatcher = MimUser(
        id: newUserId,
        username: username,
        name: name,
        createdAt: createdAt,
        birthdate: birthdate,
        gender: userGender,
        projectIds: projectsIds,
      );

      await userManagerTest.createUser(name, username, birthdate, userGender);
      FirestoreManager firestoreManagerTest = FirestoreManager(
        userId: newUserId,
        firestore: fakeFirestore,
      );

      MimUser? userResponse = await firestoreManagerTest.getUserByID(newUserId);

      expect(userResponse, userMatcher,
          reason: 'User must be the same as the one created');

      //
      // GnomeeUser? userResponse = await userManager.createUser(userModel.name,
      //     userModel.username, userModel.birthDate, userModel.gender);
      // expect(userResponse, userModel,
      //     reason: 'User must be the same as the one created');
      //
      // // Verify that the user has been added to Firestore
      // final userSnapshot =
      //     await fakeFirestore.collection('users').doc('testUserId').get();
      // GnomeeUser userFromSnapshot = GnomeeUser.fromJson(userSnapshot);
      //
      // expect(userSnapshot.exists, true);
      // expect(userModel, userFromSnapshot);
      //
      // // get user from Firestore
      // GnomeeUser? user = await userManager.getUserById(userModel.id);
      // expect(userModel, user,
      //     reason: 'User must be the same as the one created');
      //
      // GnomeeUser? user2 = await userManager.getUserById('');
      // expect(user2, null, reason: 'User must be null');
    });

    test('Try to create user using same ID', () async {
      String secondID = 'secondID';
      UserManager userManagerTest = UserManager(
        userId: secondID,
        firestoreManager: firestoreManager,
      );

      String username = 'new.username';
      DateTime birthdate = DateTime(2000, 1, 1);
      UserGender userGender = UserGender.notBinary;
      String name = 'new name';

      await userManagerTest.createUser(name, username, birthdate, userGender);

      String? errorIDAlreadyInUse = await userManagerTest.createUser(
          name, username, birthdate, userGender);
      expect(errorIDAlreadyInUse, isNotNull,
          reason:
              'There should be an error when trying to create a user with the same ID');

      // try to create a user with the same username
      UserManager userManagerTest2 = UserManager(
        userId: 'thirdID',
        firestoreManager: firestoreManager,
      );

      String? errorUsername = await userManagerTest2.createUser(
          name, username, birthdate, userGender);
      expect(errorUsername, isNotNull,
          reason:
              'There should be an error when trying to create a user with the same username');
    });

  });
}
