import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimbo/data/repositories/project_manager.dart';

import '../../logic/cubits/user_cubit.dart';
import '../../presentation/screens/create_user_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../constants.dart';
import '../models/users.dart';
import 'firebase_manager.dart';

class UserManager {
  FirestoreManager firestoreManager;
  String userId;

  UserManager({required this.userId, required this.firestoreManager});

  Future<void> loadUser(BuildContext context) async {
    /// Loads the user from the Firestore database. If the user does not exist,
    /// the user is redirected to the [CreateMimUserScreen]. If the user exists,
    /// the user is redirected to the [HomeScreen].
    /// it also updates blocs with user data and project data.

    // BlocProvider.of<LoadingUserDisplayBloc>(context)
    //     .add(LoadingUserStartedEvent());
    // await Future.delayed(const Duration(seconds: 1));
    //
    // FirestoreManager firestoreManager =
    //     FirestoreManager(userId: userId, firestore: FirebaseFirestore.instance);
    // MimUser? mimUser;
    // try {
    //   mimUser = await firestoreManager.getUserByID(userId);
    // } catch (e) {
    //   log('Error loading user: $e');
    //   BlocProvider.of<LoadingUserDisplayBloc>(context)
    //       .add(ErrorLoadingUserEvent());
    //   await Future.delayed(const Duration(seconds: 1));
    //
    //   return;
    // }
    //
    // if (mimUser == null) {
    //   BlocProvider.of<LoadingUserDisplayBloc>(context).add(UserNotFoundEvent());
    //   await Future.delayed(const Duration(seconds: 1));
    // } else {
    //   // update the user state
    //   BlocProvider.of<MimUserCubit>(context).updateUser(mimUser);
    //   await Future.delayed(const Duration(seconds: 1));
    //
    //   // load project
    //   if (mimUser.projectIds.isNotEmpty) {
    //     BlocProvider.of<LoadingUserDisplayBloc>(context)
    //         .add(LoadProjectsStartedEvent());
    //     await Future.delayed(const Duration(seconds: 1));
    //
    //     ProjectManager projectManager =
    //         ProjectManager(userId: userId, firestoreManager: firestoreManager);
    //     projectManager.loadProject(mimUser.projectIds[0], context);
    //   }
    //
    //   BlocProvider.of<LoadingUserDisplayBloc>(context)
    //       .add(LoadingCompleteEvent());
    // }
  }

  Future<String?> createUser(
    String name,
    String username,
    DateTime birthdate,
    UserGender userGender,
  ) async {
    String? error;

    try {
      MimUser mimUser = MimUser(
        id: userId,
        name: name,
        username: username,
        birthdate: birthdate,
        gender: userGender,
        createdAt: DateTime.now(),
        projectIds: const [],
      );

      await firestoreManager.createUser(mimUser);
    } on UsernameAlreadyExistsException {
      error = 'Username already exists';
    } on IDAlreadyExistsException {
      error = 'User ID already exists';
    } on AssertionError catch (e) {
      error = e.toString();
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
