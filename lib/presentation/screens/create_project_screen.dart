import 'package:flutter/material.dart';

import '../widget/widgets.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DDownProjectCategory _projectCategoryMenu = DDownProjectCategory();

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

          const Text('Install instructions'),
          TextFormField(
            controller: _officialUrlController,
            decoration: const InputDecoration(
              labelText: 'Official URL',
            ),

          ),
          KeywordsInput(),

          ElevatedButton(onPressed: () {}, child: Text('Create Project')),
        ],
      ),
    );
  }
}

// final Map<String, String> installationUrls;
// final List<String> keywords;
// final List<String> languages;
// final List<String> screenshotsPics;

// final DateTime createdAt;
// final String ownerId;
// final String id;
// final List<String> unreadAnswersIds;
// final List<String> feedbackAssessmentIds;
