import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../data/constants.dart';
import '../../data/utils/date_tools.dart';
import '../../logic/cubits/user_cubit.dart';
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

// ignore: must_be_immutable
class BirthdatePicker extends StatefulWidget {
  DateTime? selectedDate;

  BirthdatePicker({super.key});

  @override
  BirthdatePickerState createState() => BirthdatePickerState();
}

class BirthdatePickerState extends State<BirthdatePicker> {
  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    // select 18 years before today
    final DateTime date18yearsAgo = DateTools().getYearsAgo(18);
    final DateTime firstDate = DateTools().getYearsAgo(130);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date18yearsAgo,
      firstDate: firstDate,
      lastDate: date18yearsAgo,
    );

    if (pickedDate != null && pickedDate != widget.selectedDate) {
      setState(() {
        widget.selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          // AppLocalizations.of(context)!.createUserScreenBirthDateLabel,
          'birthDateLabel',

          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Gap(10),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // TODO use theme data
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.selectedDate == null
                      // ? AppLocalizations.of(context)!.datePickerLabel // 'Select a date'
                      ? 'Select a date'
                      : '${widget.selectedDate!.toLocal()}'.split(' ')[0],
                  // Format date as YYYY-MM-DD
                  style: const TextStyle(fontSize: 16.0),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class GenderSelectorDropAndDown extends StatefulWidget {
  GenderSelectorDropAndDown({super.key});

  UserGender selectedValue = UserGender.male;

  @override
  State<GenderSelectorDropAndDown> createState() =>
      _GenderSelectorDropAndDownState();
}

class _GenderSelectorDropAndDownState extends State<GenderSelectorDropAndDown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Select your Gender'),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            // color is set according the theme
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.grey.shade800,
          ),
          child: DropdownButton<UserGender>(
            value: widget.selectedValue,
            icon: const Icon(Icons.arrow_downward),
            onChanged: (UserGender? value) {
              // This is called when the user selects an item.
              setState(() {
                widget.selectedValue = value!;
              });
            },
            dropdownColor: Colors.white,
            // Set the background color of the dropdown menu
            items: UserGender.values
                .map<DropdownMenuItem<UserGender>>((UserGender value) {
              return DropdownMenuItem<UserGender>(
                value: value,
                child: Text(genderParser(value, context)),
              );
            }).toList(),
          ),
        ),
        const Gap(10),
        IconButton(
            onPressed: () {
              // Display a modal with information why gender is required
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'))
                        ],
                        title: const Text('Why do ask for your gender'),
                        content: const SizedBox(
                          height: 200,
                          width: 300,
                          child: Column(
                            children: [
                              Text('genderRequiredInfo'),
                              Gap(10),
                              Text('genderRequiredInfo2'),
                            ],
                          ),
                        ),
                      ));
            },
            icon: const Icon(Icons.info)),
      ],
    );
  }

  String genderParser(UserGender userGender, BuildContext context) {
    switch (userGender) {
      case UserGender.male:
        return 'genderMale';
      // return AppLocalizations.of(context)!.genderMale;
      case UserGender.female:
        return 'genderMale';
      // return AppLocalizations.of(context)!.genderFemale;
      case UserGender.notBinary:
        return 'genderMale';
      // return AppLocalizations.of(context)!.genderNotBinary;
      case UserGender.notDisclosed:
        return 'genderMale';
      // return AppLocalizations.of(context)!.genderNonDisclosed;
      case UserGender.other:
        return 'genderMale';
      // TODO: Handle this case.
    }
  }
}

class UsernameDisplay extends StatelessWidget {
  String previousText;
  String postText;

  UsernameDisplay([this.previousText = '', this.postText = '']);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MimUserCubit, MimUserState>(
      builder: (context, state) {
        if (state.user == null) {
          return Text('User not logged in.');
        } else {
          return Text('$previousText${state.user!.username}$postText');
        }
      },
    );
  }
}
