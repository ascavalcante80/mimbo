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

    // test('Create User - Fields validation', () async {
    //   DateTime today = DateTime.now();
    //   DateTime birthDateLessThan18 =
    //       DateTime(today.year - 17, today.month, today.day);
    //
    //   bool catchAge = false;
    //   try {
    //     await userManager.createUser(
    //         'name', 'username', birthDateLessThan18, UserGender.notBinary);
    //   } on AgeNotAllowed {
    //     catchAge = true;
    //   }
    //   expect(true, catchAge,
    //       reason: 'User birthdate must be at least 18 years old');
    //
    //   bool catchUsername = false;
    //   try {
    //     await userManager.createUser(
    //         'name', '', DateTime.now(), UserGender.notBinary);
    //   } on IncompleteFormException {
    //     catchUsername = true;
    //   }
    //   expect(true, catchUsername, reason: 'Username must not be empty');
    //
    //   bool catchName = false;
    //   try {
    //     await userManager.createUser(
    //         '', 'username', DateTime.now(), UserGender.notBinary);
    //   } on IncompleteFormException {
    //     catchName = true;
    //   }
    //   expect(true, catchName, reason: 'Name must not be empty');
    // });
    //
    // test('User already exists', () async {
    //   DateTime today = DateTime.now();
    //   DateTime birthDate = DateTime(today.year - 18, today.month, today.day);
    //   GnomeeUser userModel = GnomeeUser(
    //     id: 'testUserId',
    //     name: 'name',
    //     username: 'username',
    //     gender: UserGender.notDisclosed,
    //     birthDate: birthDate,
    //     createdAt: DateTime.now(),
    //     reactionsCount: {},
    //   );
    //   await userManager.createUser(userModel.name, userModel.username,
    //       userModel.birthDate, userModel.gender);
    //
    //   bool catchUserAlreadyExists = false;
    //   try {
    //     await userManager.createUser(userModel.name, userModel.username,
    //         userModel.birthDate, userModel.gender);
    //   } on IDAlreadyExistsException {
    //     catchUserAlreadyExists = true;
    //   }
    //   expect(true, catchUserAlreadyExists,
    //       reason: 'Impossible to create a user with the same ID');
    // });
    //
    // test('Username already exists', () async {
    //   String id1 = '1';
    //   String id2 = '2';
    //   String sameUsername = 'username';
    //   firestoreManager =
    //       FirestoreManager(userId: id1, firestore: fakeFirestore);
    //   userManager = UserManager(uuid: id1, firestoreManager: firestoreManager);
    //
    //   GnomeeUser user1 = GnomeeUser(
    //     id: id1,
    //     name: 'name',
    //     username: sameUsername,
    //     gender: UserGender.notDisclosed,
    //     birthDate: DateTools().getYearsAgo(18),
    //     createdAt: DateTime.now(),
    //     reactionsCount: {},
    //   );
    //   await userManager.createUser(
    //       user1.name, user1.username, user1.birthDate, user1.gender);
    //
    //   firestoreManager =
    //       FirestoreManager(userId: id2, firestore: fakeFirestore);
    //   userManager = UserManager(uuid: id2, firestoreManager: firestoreManager);
    //
    //   GnomeeUser user2 = GnomeeUser(
    //     id: id2,
    //     name: 'name',
    //     username: sameUsername,
    //     gender: UserGender.notDisclosed,
    //     birthDate: DateTools().getYearsAgo(18),
    //     createdAt: DateTime.now(),
    //     reactionsCount: {},
    //   );
    //   bool catchUsernameAlreadyExists = false;
    //   try {
    //     await userManager.createUser(
    //         user2.name, user2.username, user2.birthDate, user2.gender);
    //   } on UsernameAlreadyExistsException {
    //     catchUsernameAlreadyExists = true;
    //   }
    //
    //   expect(true, catchUsernameAlreadyExists,
    //       reason: 'Impossible to create a user with the same ID');
    // });
  });
}
