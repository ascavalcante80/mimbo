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
  group('Test FeedInfo operations on Cubit', () {
    test('Test cubit to hold user info', () async {

      // TODO
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
