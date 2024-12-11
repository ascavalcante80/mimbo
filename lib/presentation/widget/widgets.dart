import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mimbo/logic/bloc/project_operations_bloc.dart';
import 'package:mimbo/presentation/screens/create_project_screen.dart';
import 'package:mimbo/presentation/screens/create_user_screen.dart';

import '../../data/constants.dart';
import '../../data/utils/date_tools.dart';
import '../../logic/bloc/user_loader_bloc.dart';
import '../../logic/bloc/user_loader_bloc.dart';
import '../../logic/cubits/page_controller_cubit.dart';
import '../../logic/cubits/project_cubit.dart';
import '../../logic/cubits/user_cubit.dart';

import '../screens/home_screen.dart';
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
    return BlocBuilder<MimUserCubit, UserState>(
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

class LoadUserDisplay extends StatelessWidget {
  const LoadUserDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<UserLoaderBloc, UserLoaderState>(
            builder: (context, state) {
          if (state is LoadingUserState) {
            return const Text('Loading user...');
          } else if (state is ErrorLoadingUserState) {
            if (state.errorType == LoaderErrorType.userNotFound) {
              return const Text('User not found');
            } else {
              return const Text('An error occurred trying to load user');
            }
          } else if (state is UserLoadedState) {
            return const Text('User loaded!');
          } else if (state is LoadingProjectState) {
            return const Text('Loading project...');
          } else if (state is ErrorLoadingProjectState) {
            if (state.errorType == LoaderErrorType.projectNotFound) {
              return const Text('Project not found');
            } else {
              return const Text('An error occurred trying to load project');
            }
          } else if (state is UsersProjectLoadedState) {
            return const Text('Project loaded!');
          } else if (state is LoadingCompleteState) {
            return const Text('Loading complete');
          } else {
            return const Text('Welcome to Mimbo');
          }
        }, listener: (context, state) {
          if (state is LoadingCompleteState) {
            BlocProvider.of<MimUserCubit>(context).loadUser(state.mimUser!);
            if (state.project != null) {
              BlocProvider.of<ProjectCubit>(context)
                  .updateProject(state.project!);
            }
            // go to home screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        })
      ],
    );
  }
}

class OfficialURLInfoButton extends StatelessWidget {
  const OfficialURLInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        displayModal(context);
      },
      icon: const Icon(Icons.info),
    );
  }

  void displayModal(BuildContext context) {
    // display a modal to confirm the creation of the project
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          children: [
            const Text('Enter here the URL point to your project page, '
                'where users can get know more about your app. '
                'The URL to install the app (.i.e: TestFlight, etc) will be '
                'added later when you create your first form feedback.'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}

class DDownProjectCategory extends StatefulWidget {
  AppCategory selectedValue = AppCategory.books;

  DDownProjectCategory({super.key});

  @override
  State<DDownProjectCategory> createState() => _DDownProjectCategoryState();
}

class _DDownProjectCategoryState extends State<DDownProjectCategory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Select a category'),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            // color is set according the theme
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.grey.shade800,
          ),
          child: DropdownButton<AppCategory>(
            value: widget.selectedValue,
            icon: const Icon(Icons.arrow_downward),
            onChanged: (AppCategory? value) {
              // This is called when the user selects an item.
              setState(() {
                widget.selectedValue = value!;
              });
            },
            dropdownColor: Colors.white,
            // Set the background color of the dropdown menu
            items: AppCategory.values
                .map<DropdownMenuItem<AppCategory>>((AppCategory value) {
              return DropdownMenuItem<AppCategory>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class KeywordsInput extends StatefulWidget {
  List<String> keywords = [];

  KeywordsInput({super.key});

  @override
  State<KeywordsInput> createState() => _KeywordsInputState();
}

class _KeywordsInputState extends State<KeywordsInput> {
  final TextEditingController _keywordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int maxKeywords = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 50,
              width: 200,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _keywordController,
                  decoration: const InputDecoration(
                    labelText: 'Keywords',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a keyword';
                    }
                    return null;
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // validate form
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                if (widget.keywords.length >= maxKeywords) {
                  maxKeywordsReached(context);
                  return;
                }
                setState(() {
                  if (!widget.keywords.contains(_keywordController.text)) {
                    widget.keywords.add(_keywordController.text);
                    _keywordController.clear();
                  }
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        chipRow(),
      ],
    );
  }

  Row chipRow() {
    return Row(
      children: widget.keywords
          .map(
            (keyword) => Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Chip(
                label: Text(keyword),
                onDeleted: () {
                  setState(() {
                    widget.keywords.remove(keyword);
                  });
                },
              ),
            ),
          )
          .toList(),
    );
  }

  void maxKeywordsReached(BuildContext context) {
    // display snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You can only add $maxKeywords keywords'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class ProjectButtonsOperations extends StatelessWidget {
  const ProjectButtonsOperations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectOperationsBloc, ProjectOperationsState>(
        builder: (context, state) {
      if (state is ProjectOperationsInitial || state is ProjectDeleted) {
        return TextButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateProjectScreen.routeName);
            },
            child: const Text('Create project'));
      } else if (state is ProjectOperationStarted) {
        return const CircularProgressIndicator();
      } else if (state is ProjectCreated ||
          state is ProjectUpdated ||
          state is ProjectLoaded) {
        return const Column(
          children: [
            EditProjectButton(),
            DeleteProjectButton(),
          ],
        );
      } else {
        return Text('estado unknown ${state.toString()}');
      }
    }, listener: (context, state) {
      if (state is ProjectDeleted) {
        // remove project from project cubit
        BlocProvider.of<ProjectCubit>(context).deleteProject(state.project!);

        // display a snack bar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Project deleted'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      if (state is ProjectUpdated) {
        // update cubit
        BlocProvider.of<ProjectCubit>(context).updateProject(state.project!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Project updated'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      if (state is ProjectCreated) {
        // update cubit
        BlocProvider.of<ProjectCubit>(context).loadProject(state.project!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Project created'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }
}

class DeleteProjectButton extends StatelessWidget {
  const DeleteProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          // fetch the project from project cubit
          final projectCubit = BlocProvider.of<ProjectCubit>(context);
          BlocProvider.of<ProjectOperationsBloc>(context).add(
              DeleteProjectButtonPressed(project: projectCubit.state.project!));
        },
        child: const Text('Delete project'));
  }
}

class EditProjectButton extends StatelessWidget {
  const EditProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          // final projectCubit = BlocProvider.of<ProjectCubit>(context);
          // BlocProvider.of<ProjectOperationsBloc>(context).add(
          //     EditProjectButtonPressed(project: projectCubit.state.project!));
          Navigator.of(context).pushNamed(CreateProjectScreen.routeName);

        },
        child: const Text('Edit project'));
  }
}
