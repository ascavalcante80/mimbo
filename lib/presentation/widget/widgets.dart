import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class GoToLoginScreenButton extends StatelessWidget {
  /// The [GoToLoginScreenButton] is a button that allows the user to navigate
  /// to the login screen. It disconnects the user from the Firebase Auth
  /// instance before navigating to the login screen.

  const GoToLoginScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        log('Signing user out!');
        await FirebaseAuth.instance.signOut();

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthGate()),
            (route) => false,
          );
        }
      },
      // child: Text(AppLocalizations.of(context)!.goToLoginMessage),
      child: const Text('Go to login screen'),
    );
  }
}

class SignOutAppBarAction extends StatelessWidget {
  /// The [SignOutAppBarAction] is a button that allows the user to navigate
  /// to the login screen. It disconnects the user from the Firebase Auth
  /// instance before navigating to the login screen.

  const SignOutAppBarAction({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        log('Signing user out!');
        await FirebaseAuth.instance.signOut();

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthGate()),
            (route) => false,
          );
        }
      },
      icon: const Icon(Icons.logout),
    );
  }
}
