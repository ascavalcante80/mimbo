import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mimbo/bloc/cubits/project_cubit.dart';
import 'package:mimbo/bloc/cubits/user_cubit.dart';
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
    test('Test cubit to hold user info', () async {
      MimUserCubit userCubit = MimUserCubit();
      String userId = 'userId';
      String name = 'name';
      String username = 'username';
      DateTime createdAt = DateTime.now();
      DateTime birthdate = DateTime.now();

      MimUser userMatcher = MimUser(
        id: userId,
        username: username,
        name: name,
        createdAt: createdAt,
        birthdate: birthdate,
        gender: UserGender.notBinary,
        projectIds: ['projectId'],
      );

      userCubit.updateUser(userMatcher);
      expect(userCubit.state.user, userMatcher,
          reason: 'MimUser must be the same as the one created');
      MimUser userUpdated = MimUser(
        id: userId,
        username: 'updatedUsername',
        name: name,
        createdAt: createdAt,
        birthdate: birthdate,
        gender: UserGender.notBinary,
        projectIds: ['projectId'],
      );

      userCubit.updateUser(userUpdated);

      expect(userCubit.state.user, userUpdated,
          reason: 'MimUser must be the same as the one updated');

      // blocTest<SubjectBloc, SubjectState>(
      //   'TODO: description',
      //   build: () => SubjectBloc(),
      //   act: (bloc) {
      //     // TODO: implement
      //   },
      //   expect: () => <SubjectState>[
      //     // TODO: implement
      //   ],
      // );
    });
  });
}
