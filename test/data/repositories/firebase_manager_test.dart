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

    test('Test create and read operations ', () async {
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

      expect(userResponse, userMatcher, reason: 'User must be the same as the one created');
    });
  });
}
