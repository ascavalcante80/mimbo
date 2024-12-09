import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/projects.dart';
import '../../logic/bloc/project_bloc.dart';
import '../../logic/cubits/page_controller_cubit.dart';
import '../../logic/cubits/user_cubit.dart';
import '../widget/widgets.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DDownProjectCategory _projectCategoryMenu = DDownProjectCategory();
  final KeywordsInput _keywordsInput = KeywordsInput();

  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _officialUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
          const Text('The URLs to install the project will be added later, '
              'when you create your first test.'),
          _keywordsInput,
          // button to add screenshots
          Row(
            children: [
              const Text('Add screenshots of app'),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.camera_alt_outlined)),
            ],
          ),
          saveProject(),
        ],
      ),
    );
  }

  BlocConsumer saveProject() {
    return BlocConsumer<ProjectButtonBloc, ProjectState>(
      listener: (context, state) {
        // return to the lab room
        if (state is ProjectSavedState) {
          BlocProvider.of<PageControllerCubit>(context)
              .updateCurrentPageIndex(0);
        }
      },
      builder: (context, state) {
        if (state is SavingProjectState) {
          log('Saving project....');
          return const CircularProgressIndicator();
        } else if (state is ProjectSavedState) {
          return const Text('Project saved!');
        } else if (state is ErrorSavingProjectSate) {
          return const Text('Error saving project');
        }
        return Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  // clear the form
                  clearForm();

                  // return to the lab room
                  BlocProvider.of<PageControllerCubit>(context)
                      .updateCurrentPageIndex(0);
                },
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () async {
                  // validate the form

                  String userId =
                      BlocProvider.of<MimUserCubit>(context).state.user!.id;
                  Project project = Project.emptyProject(
                    ownerId: userId,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    category: _projectCategoryMenu.selectedValue.toString(),
                    officialUrl: _officialUrlController.text,
                    keywords: _keywordsInput.keywords,
                  );

                  // emit state button pressed
                  BlocProvider.of<ProjectButtonBloc>(context)
                      .add(SaveProjectButtonPressed(project: project));
                  clearForm();
                },
                child: const Text('Create Project')),
          ],
        );
      },
    );
  }

  void clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _officialUrlController.clear();
    _keywordsInput.keywords.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _officialUrlController.dispose();
    super.dispose();
  }
}
