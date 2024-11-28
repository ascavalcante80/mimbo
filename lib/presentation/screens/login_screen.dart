import 'dart:developer';
import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mimbo/presentation/widget/widgets.dart';

class AuthGate extends StatelessWidget {
  /// The [AuthGate] is a screen that allows the user to sign in or sign up.

  static const String routeName = '/';

  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // if user is signed in, go to home screen
          // user have validated the e-mail
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            // retrieve user data
            log('User is signed in');
            return const UserLoadingScreen();
          } else {
            log('User is signed in, but email is not verified');
            return const WaitingConfirmationEmail();
          }
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error occurred'),
            ),
          );
        } else {
          log('User is not signed in');
          return SignInScreen(
            providers: [
              // PhoneAuthProvider(),
              EmailAuthProvider(),
            ],
            actions: [
              ForgotPasswordAction((context, email) {
                log('Forgot email action');
                if (email == null) {
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(email: email)),
                );
              }),
              AuthStateChangeAction<UserCreated>((context, state) async {
                log('User created action');

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserCreatedScreen()));
              }),
              AuthStateChangeAction<SignedIn>((context, state) async {
                log('Signed In action');

                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserLoadingScreen()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WaitingConfirmationEmail()),
                  );
                }
              }),
              SignedOutAction((context) {
                log('Signed Out action');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignedOutScreen()),
                );
              }),
            ],
          );
        }
      },
    );
  }

  Future<void> handleUserSignedIn(BuildContext context) async {
    // check if has confirmed email
    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const WaitingConfirmationEmail()),
      );
    }
    try {
      // FirestoreManager firestoreManager = FirestoreManager.noUserId(
      //   firestore: FirebaseFirestore.instance,
      // );
      //
      // try {
      //   String uid = FirebaseAuth.instance.currentUser!.uid;
      //   GnomeeUser? gnomeUser = await firestoreManager.getUserByID(uid);
      //
      //   if (!context.mounted) {
      //     log('=====> Context was not mounted');
      //     FirebaseAuth.instance.signOut();
      //     return;
      //   }
      //
      //   if (gnomeUser == null) {
      //     // user has already logged in, but has not created an account
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => CreateUserScreen(uuid: uid)),
      //     );
      //   } else {
      //     BlocProvider.of<UserCubit>(context).setUser(gnomeUser);
      //     BlocProvider.of<AnalyticsCubit>(context)
      //         .analyticsManager
      //         .setUserProperties(gnomeUser);
      //     log('User signed in: ${gnomeUser.id}');
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const SearchPage()),
      //     );
      //   }
    } catch (e) {
      // display error message and return to sign in
      FirebaseAuth.instance.signOut();
    }
  }
}

class UserLoadingScreen extends StatefulWidget {
  const UserLoadingScreen({super.key});

  @override
  State<UserLoadingScreen> createState() => _UserLoadingScreenState();
}

class _UserLoadingScreenState extends State<UserLoadingScreen> {
  @override
  void initState() {
    super.initState();
    loadDataAndRedirect(context);
  }

  Future<void> loadDataAndRedirect(BuildContext context) async {
    // FirestoreManager firestoreManager = FirestoreManager.noUserId(
    //   firestore: FirebaseFirestore.instance,
    // );
    //
    // UserManager userManager = UserManager(
    //     firestoreManager: firestoreManager,
    //     uuid: FirebaseAuth.instance.currentUser!.uid);
    //
    // await userManager.loadUser(context).then((gnomeeUser) {
    //   if (!context.mounted) return;
    //
    //   if (gnomeeUser == null) {
    //     String uuid = FirebaseAuth.instance.currentUser!.uid;
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => CreateUserScreen(
    //                 uuid: uuid,
    //               )),
    //     );
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const SearchPage()),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.app_bar_title_loading_user_s),
      ),
      body: Center(
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.label_loading_user_message),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// class LoginErrorScreen extends StatelessWidget {
//   const LoginErrorScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.loginErrorTitle),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(AppLocalizations.of(context)!.loginErrorMessage),
//               TextButton(
//                 onPressed: () {
//                   // go to sign in screen
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const AuthGate()),
//                   );
//                 },
//                 child: Text(AppLocalizations.of(context)!.tryAgainButton),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
class SignedOutScreen extends StatelessWidget {
  const SignedOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(AppLocalizations.of(context)!.signedOutTitle),
      // ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(AppLocalizations.of(context)!.seeYouSoonMessage),
      //       TextButton(
      //         onPressed: () {
      //           // go to sign in screen
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(builder: (context) => const AuthGate()),
      //           );
      //         },
      //         child: Text(AppLocalizations.of(context)!.goToLoginButton),
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [Text('Sign out screen')],
      ),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  static String routeName = '/forgot_password';
  final String email;

  const ResetPasswordScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(AppLocalizations.of(context)!.passwordResetTitle),
      // ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(AppLocalizations.of(context)!.passwordResetMessage),
      //       TextButton(
      //         onPressed: () {
      //           FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      //         },
      //         child: Text(AppLocalizations.of(context)!.sendEmailButton),
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [Text('Reser password screen')],
      ),
    );
  }
}

class UserCreatedScreen extends StatefulWidget {
  /// The [UserCreatedScreen] is a screen that is displayed when the user has
  /// successfully created an account.
  /// When this screen is displayed, the user is sent a confirmation email to
  /// verify their email address. It also starts a timer to resend the email
  /// after 2 minutes.

  const UserCreatedScreen({super.key});

  @override
  State<UserCreatedScreen> createState() => _UserCreatedScreenState();
}

class _UserCreatedScreenState extends State<UserCreatedScreen> {
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // sends the user to the confirmation email screen after 2 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Text(AppLocalizations.of(context)!.confirmationEmailTitle),
        title: Text('Confirmation email title'),
        // actions: const [
        //   SignOutFromGnomeeButton(),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(AppLocalizations.of(context)!.verifyYourInboxMessage),
            Text('Verify your inbox message'),
            const Gap(35),
            const GoToLoginScreenButton(),
          ],
        ),
      ),
    );
  }
}

class WaitingConfirmationEmail extends StatefulWidget {
  /// This widget is displayed when the user needs to confirm their email
  /// address. It allows the user to resend the confirmation email. The button
  /// remains unavailable for 2 minutes, before the user can click it on again.

  static const String id = 'confirmation_email_screen';

  const WaitingConfirmationEmail({super.key});

  @override
  State<WaitingConfirmationEmail> createState() =>
      _WaitingConfirmationEmailState();
}

class _WaitingConfirmationEmailState extends State<WaitingConfirmationEmail> {
  Duration _duration = const Duration(seconds: 120);
  Timer? _timer;
  String errorMessage = '';
  bool timerStarted = false;

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  // Method to start the countdown timer
  void startTimer() {
    timerStarted = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds <= 0) {
        // Countdown is finished
        _timer?.cancel();
        setState(() {
          // SessionConfig.emailResendCounter = 0;
          timerStarted = false;
        });
      } else {
        // Update the countdown value and decrement by 1 second
        setState(() {
          // SessionConfig.emailResendCounter = _duration.inSeconds;
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!
            .app_bar_title_waiting_confirmation_email_s),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, AuthGate.routeName);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Text(AppLocalizations.of(context)!.label_verify_your_email),
      //       const Gap(20),
      //       // timerStarted
      //       //     ? Text(AppLocalizations.of(context)!.countingDownWaitMessage(
      //       //         SessionConfig.emailResendCounter.toString()))
      //       //     : resendEmailButton(),
      //       // go to sign in screen button
      //       const Gap(40),
      //       goToLoginButton(context),
      //     ],
      //   ),
      //
      // ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Waiting confirmation email screen')],
      ),
    );
  }

  TextButton goToLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.pushNamed(context, AuthGate.routeName);
      },
      child: Text(AppLocalizations.of(context)!.button_go_to_login),
    );
  }

  TextButton resendEmailButton() {
    return TextButton(
        onPressed: () async {
          bool error = false;
          try {
            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          } catch (e) {
            error = true;
          }

          if (error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  duration: const Duration(seconds: 3),
                ),
              );
            } else {
              setState(() {
                errorMessage = AppLocalizations.of(context)!
                    .label_error_message_email_not_confirmed;
              });
            }
            return;
          }

          startTimer();
        },
        child: Text(AppLocalizations.of(context)!.button_resend_email));
  }
}
