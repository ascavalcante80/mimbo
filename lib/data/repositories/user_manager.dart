import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/presentation/screens/create_user_screen.dart';

import '../../presentation/screens/home_screen.dart';
import '../models/users.dart';
import 'firebase_manager.dart';

class UserManager {
  FirestoreManager firestoreManager;

  UserManager({required this.firestoreManager});

  Future<void> loadUser(BuildContext context, Function operationUpdate) async {
    /// Loads the user from the Firestore database. If the user does not exist,
    /// the user is redirected to the [CreateMimUserScreen]. If the user exists,
    /// the user is redirected to the [HomeScreen].
    /// it also updates blocs with user data and project data.

    await operationUpdate('loading Mimbo user...');

    String userId = FirebaseAuth.instance.currentUser!.uid;

    FirestoreManager firestoreManager =
        FirestoreManager(userId: userId, firestore: FirebaseFirestore.instance);
    MimUser? mimUser;
    try {
      mimUser = await firestoreManager.getUserByID(userId);
    } catch (e) {
      log('Error loading user: $e');
      await operationUpdate(
          "Error loading user. Please restart the app. If the problem persists, contact support.");
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
    MimUser mimUser = MimUser(
      id: FirebaseAuth.instance.currentUser!.uid,
      name: name,
      username: username,
      birthdate: birthdate,
      gender: userGender,
      createdAt: DateTime.now(),
    );

    try {
      await firestoreManager.createUser(mimUser);
    } on UsernameAlreadyExistsException {
      error = 'Username already exists';
    } on IDAlreadyExistsException {
      error = 'User ID already exists';
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
