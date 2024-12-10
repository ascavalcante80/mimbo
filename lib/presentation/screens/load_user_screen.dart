import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mimbo/logic/bloc/user_bloc.dart';
import 'package:mimbo/presentation/widget/widgets.dart';

import '../../data/repositories/firebase_manager.dart';
import '../../data/repositories/user_manager.dart';

class UserLoadingScreen extends StatefulWidget {
  /// The [UserLoadingScreen] is displayed when the user is signed in and
  /// the email is verified. It loads the user data and redirects the user to
  /// the home screen.

  const UserLoadingScreen({super.key});

  @override
  State<UserLoadingScreen> createState() => _UserLoadingScreenState();
}

class _UserLoadingScreenState extends State<UserLoadingScreen> {
  @override
  void initState() {
    super.initState();
    assert(FirebaseAuth.instance.currentUser != null);
    assert(FirebaseAuth.instance.currentUser!.emailVerified);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDataAndRedirect();
    });
  }

  String message = '';

  Future<void> loadDataAndRedirect() async {
    /// The [loadDataAndRedirect] method loads the user data and redirects the
    /// app to the home screen. If the user data is not found, it displays an
    /// error message.

    String userId = FirebaseAuth.instance.currentUser!.uid;
    BlocProvider.of<UserBloc>(context).add(GetUserEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.app_bar_title_loading_user),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadUserDisplay(),
          ],
        ),
      ),
    );
  }

  SizedBox errorDisplay() {
    return const SizedBox(
      child: Column(
        children: [
          Text('An error occurred trying to login again.'),
          Gap(20),
          GoToLoginScreenButton(),
        ],
      ),
    );
  }
}
