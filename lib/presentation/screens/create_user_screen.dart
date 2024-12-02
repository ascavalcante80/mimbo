import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/repositories/user_manager.dart';
import 'package:mimbo/presentation/screens/home_screen.dart';

import '../../data/repositories/firebase_manager.dart';
import '../../utils/field_validator.dart';
import '../widget/widgets.dart';

class CreateMimUserScreen extends StatefulWidget {
  static const String routeName = '/create_user';

  const CreateMimUserScreen({super.key});

  @override
  State<CreateMimUserScreen> createState() => _CreateMimUserScreenState();
}

class _CreateMimUserScreenState extends State<CreateMimUserScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  BirthdatePicker birthdatePicker = BirthdatePicker();
  GenderSelectorDropAndDown genderSelector = GenderSelectorDropAndDown();
  bool savingInProgress = false;
  String? contextError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create User Screen'),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              const Text('Welcome to the Create User Screen'),
              usernameInputField(context),
              nameInputField(context),
              birthdatePicker,
              genderSelector,
              savingInProgress
                  ? const CircularProgressIndicator()
                  : createUserButton(context),
              if (contextError != null) Text(contextError!),
            ],
          ),
        ));
  }

  ElevatedButton createUserButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          contextError = null;
          setState(() {
            savingInProgress = true;
          });

          if (!formKey.currentState!.validate()) {
            setState(() {
              savingInProgress = false;
            });
            return;
          }

          if (birthdatePicker.selectedDate == null) {
            setState(() {
              savingInProgress = false;
              contextError = 'Please select a birthdate';
            });
            return;
          }

          UserManager userManager = UserManager(
              firestoreManager: FirestoreManager(
            userId: FirebaseAuth.instance.currentUser!.uid,
            firestore: FirebaseFirestore.instance,
          ));

          String? errorMessage = await userManager.createUser(
            nameController.text,
            usernameController.text,
            birthdatePicker.selectedDate!,
            genderSelector.selectedValue,
          );

          if (!context.mounted) {
            setState(() {
              savingInProgress = false;
              contextError = 'An error occurred, please try again later';
            });
            return;
          }

          if (errorMessage != null) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(errorMessage),
            ));
            setState(() {
              savingInProgress = false;
            });
          } else {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }
        },
        child: const Text('Create User'));
  }

  TextFormField usernameInputField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Username'),
      controller: usernameController,
      validator: (value) {
        return InputValidator.validateUsernameField(value, context);
      },
    );
  }

  TextFormField nameInputField(BuildContext context) {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Name'),
        controller: nameController,
        validator: (value) {
          return InputValidator.validateProperNounsField(value, context);
        });
  }
}
