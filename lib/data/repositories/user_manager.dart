import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimbo/bloc/cubits/user_cubit.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/models/projects.dart';
import 'package:mimbo/data/repositories/project_manager.dart';
import 'package:mimbo/presentation/screens/create_user_screen.dart';

import '../../presentation/screens/home_screen.dart';
import '../models/users.dart';
import 'firebase_manager.dart';

class UserManager {
  FirestoreManager firestoreManager;
  String userId;

  UserManager({required this.userId, required this.firestoreManager});

  Future<void> loadUser(BuildContext context, Function operationUpdate) async {
    /// Loads the user from the Firestore database. If the user does not exist,
    /// the user is redirected to the [CreateMimUserScreen]. If the user exists,
    /// the user is redirected to the [HomeScreen].
    /// it also updates blocs with user data and project data.

    await operationUpdate('loading Mimbo user...');

    FirestoreManager firestoreManager =
        FirestoreManager(userId: userId, firestore: FirebaseFirestore.instance);
    MimUser? mimUser;
    try {
      mimUser = await firestoreManager.getUserByID(userId);
    } catch (e) {
      log('Error loading user: $e');
      // sets the message to empty to make go to login button visible
      await operationUpdate("");
      return;
    }

    if (mimUser == null) {
      if (context.mounted) {
        await operationUpdate("Please create a user account.");
      }
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateMimUserScreen(),
          ),
        );
      }

      return;
    } else {
      if (!context.mounted) {
        await operationUpdate(
            "Error loading user. Please restart the app. If the problem persists, contact support.");
        return;
      } else {
        // update the user state
        BlocProvider.of<MimUserCubit>(context).updateUser(mimUser);

        // load project
        if (mimUser.projectIds.isNotEmpty) {
          ProjectManager projectManager = ProjectManager(userId: userId, firestoreManager: firestoreManager);
          projectManager.loadProject(mimUser.projectIds[0], context);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
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
