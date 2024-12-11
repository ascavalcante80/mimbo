import 'package:flutter_test/flutter_test.dart';
import 'package:mimbo/logic/cubits/user_cubit.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/models/users.dart';

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

      userCubit.loadUser(userMatcher);
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

      userCubit.loadUser(userUpdated);

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
