import 'dart:developer';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mimbo/data/models/users.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';
import 'package:mimbo/presentation/screens/home_screen.dart';
import 'package:mimbo/presentation/widget/widgets.dart';

import '../../data/repositories/user_manager.dart';

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
          return Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context)!.label_generic_error),
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
                      builder: (context) => ForgotPasswordScreen(email: email)),
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
}

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
      loadDataAndRedirect(context);
    });
  }

  String message = '';

  Future<void> loadDataAndRedirect(BuildContext context) async {
    /// The [loadDataAndRedirect] method loads the user data and redirects the
    /// app to the home screen. If the user data is not found, it displays an
    /// error message.
    UserManager userManager = UserManager();
    await userManager.loadUser(context, updateMessage);


  }

  Future<void> updateMessage(String message) async {
    /// Updates the message displayed on the screen.
    setState(() {
      this.message = message;
    });
    await Future.delayed(const Duration(seconds: 2));
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
            Text(message),
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
    return const Scaffold(
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

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = '/forgot_password';
  final String email;

  const ForgotPasswordScreen({required this.email, super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> emailInputKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  bool sendingEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(AppLocalizations.of(context)!.passwordResetTitle),
        title: const Text('Password reset title'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthGate()),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              // AppLocalizations.of(context)!.passwordResetMessage,
              'Password reset message',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(20),
            emailInput(context),
            const Gap(20),
            sendingEmail
                ? const CircularProgressIndicator()
                : sendResetEmailButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton sendResetEmailButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!emailInputKey.currentState!.validate()) {
          return;
        }

        setState(() {
          sendingEmail = true;
        });

        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: emailController.text.trim());

          if (!context.mounted) {
            setState(() {
              sendingEmail = false;
            });
            return;
          }

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ConfirmationResetEmailSent(),
            ),
            (route) => false,
          );
        } on FirebaseAuthException catch (firebaseException) {
          if (!context.mounted) {
            setState(() {
              sendingEmail = false;
            });
            return;
          }

          if (firebaseException.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.snack_m_user_not_found),
                duration: const Duration(seconds: 3),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.snack_m_password_reset_error),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          log('Error sending password reset email: $e');
          if (!context.mounted) {
            setState(() {
              sendingEmail = false;
            });
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.snack_m_password_reset_error),
              duration: const Duration(seconds: 3),
            ),
          );
        }

        // stop loading
        setState(() {
          sendingEmail = false;
        });
      },
      child: Text(AppLocalizations.of(context)!.send_reset_email_button),
    );
  }

  Padding emailInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: emailInputKey,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!
                  .input_label_email_reset_confirmation),
          validator: (emailInput) {
            if (emailInput == null || emailInput.isEmpty) {
              return AppLocalizations.of(context)!
                  .input_error_empty_email_reset_confirmation;
            } else if (emailInput.isEmpty) {
              return AppLocalizations.of(context)!
                  .input_error_empty_email_reset_confirmation;
            } else if (!EmailValidator.validate(emailInput.trim())) {
              return AppLocalizations.of(context)!
                  .input_error_email_reset_confirmation;
            } else {
              return null;
            }
          },
        ),
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
        title: const Text('Confirmation email title'),
        actions: const [
          SignOutAppBarAction(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(AppLocalizations.of(context)!.verifyYourInboxMessage),
            const Text('Verify your inbox message'),
            const Gap(20),
            Text(AppLocalizations.of(context)!.label_user_created_message),
            const Gap(35),
            const GoToLoginScreenButton(),
          ],
        ),
      ),
    );
  }
}

class ConfirmationResetEmailSent extends StatelessWidget {
  const ConfirmationResetEmailSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!
                .label_confirmation_reset_password_email_sent,
            textAlign: TextAlign.center,
          ),
          const Gap(20),
          const GoToLoginScreenButton(),
        ],
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

      body: const Column(
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
