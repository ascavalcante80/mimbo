import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimbo/data/utils/misc_parsers.dart';
import 'package:mimbo/logic/bloc/project_operations_bloc.dart';
import 'package:mimbo/logic/cubits/project_cubit.dart';

import '../../data/models/projects.dart';
import '../../logic/cubits/page_controller_cubit.dart';
import '../../logic/cubits/user_cubit.dart';
import '../widget/widgets.dart';

class CreateProjectScreen extends StatefulWidget {
  static const String routeName = '/create_project';

  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  late Project project;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DDownProjectCategory _projectCategoryMenu = DDownProjectCategory();
  final KeywordsInput _keywordsInput = KeywordsInput();
  final List<String> _urlsScreenshots = [];

  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _officialUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    fillForm(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                _projectCategoryMenu,
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: _officialUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Official URL',
                        ),
                      ),
                    ),
                    const OfficialURLInfoButton(),
                  ],
                ),
                const Text(
                    'The URLs to install the project will be added later, '
                    'when you create your first test.'),
                _keywordsInput,
                // button to add screenshots
                Row(
                  children: [
                    const Text('Add screenshots of app'),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined)),
                  ],
                ),
                bottomButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fillForm(BuildContext context) {
    // bloc has project loaded state
    if (BlocProvider.of<ProjectCubit>(context).state is ProjectLoadedState) {
      project = BlocProvider.of<ProjectCubit>(context).state.project!;
      _nameController.text = project.name;
      _descriptionController.text = project.description;
      _officialUrlController.text = project.officialUrl;
      _keywordsInput.keywords = List<String>.from(project.keywords);
      _projectCategoryMenu.selectedValue = project.category;
      _urlsScreenshots.addAll(project.screenshotsPics);
    }
  }

  BlocConsumer bottomButtons() {
    return BlocConsumer<ProjectOperationsBloc, ProjectOperationsState>(
      listener: (context, state) {
        // return to the lab room
        if (state is ProjectOperationCompleted) {
          BlocProvider.of<PageControllerCubit>(context)
              .updateCurrentPageIndex(0);
        }
      },
      builder: (context, state) {
        if (state is ProjectOperationStarted) {
          return const CircularProgressIndicator();
        } else {
          return Row(
            children: [
              cancelButton(),
              saveProjectButtonSelector(),
            ],
          );
        }
      },
    );
  }

  ElevatedButton cancelButton() {
    return ElevatedButton(
        onPressed: () {
          // clear the form
          clearForm();

          // return to the lab room
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'));
  }

  BlocConsumer saveProjectButtonSelector() {
    return BlocConsumer<ProjectCubit, ProjectState>(builder: (context, state) {
      if (state is ProjectInitial) {
        return ElevatedButton(
          onPressed: () {
            if (validateForm(context)) {
              // emit state button pressed
              Project project = buildProject();
              BlocProvider.of<ProjectOperationsBloc>(context)
                  .add(CreateProjectButtonPressed(project: project));
              clearForm();
            }
          },
          child: const Text('Create Project'),
        );
      } else if (state is ProjectLoadedState) {
        return ElevatedButton(
          onPressed: () {
            if (validateForm(context)) {
              // emit state button pressed
              BlocProvider.of<ProjectOperationsBloc>(context)
                  .add(SaveChangesButtonPressed(project: project));
              clearForm();
            }
          },
          child: const Text('Save Project'),
        );
      } else {
        return const Text('Error loading project status');
      }
    }, listener: (context, state) {
      // return to the lab room
      Navigator.of(context).pop();
    });
  }

  bool validateForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // save the project
      if (_keywordsInput.keywords.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please add at least one keyword'),
        ));
        return false;
      }

      // if (_urlsScreenshots.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Please add at least one screenshot'),
      //   ));
      //   return false;
      // }
      return true;
    } else {
      return false;
    }
  }

  void clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _officialUrlController.clear();
    _keywordsInput.keywords.clear();
    _urlsScreenshots.clear();
  }

  Project buildProject() {
    return Project.emptyProject(
      ownerId: BlocProvider.of<MimUserCubit>(context).state.user!.id,
      name: _nameController.text,
      description: _descriptionController.text,
      category: _projectCategoryMenu.selectedValue,
      officialUrl: _officialUrlController.text,
      keywords: List<String>.from(_keywordsInput.keywords),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _officialUrlController.dispose();
    super.dispose();
  }
}
