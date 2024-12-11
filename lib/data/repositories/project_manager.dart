// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mimbo/logic/bloc/project_bloc.dart';
// import 'package:mimbo/logic/cubits/user_cubit.dart';
//
// import '../../logic/cubits/project_cubit.dart';
// import '../models/projects.dart';
// import 'firebase_manager.dart';
//
// class ProjectManager {
//   String userId;
//   FirestoreManager firestoreManager;
//
//   ProjectManager({required this.userId, required this.firestoreManager});
//
//   void loadProject(String projectId, BuildContext context) async {
//     /// fetches the project from the Firestore database and loads it to Cubit.
//     /// Throws an error if the project does not exist.
//
//     try {
//       // fetch project from Firestore
//       Project? project = await firestoreManager.getProjectByID(projectId);
//
//       // load mock project
//       if (!context.mounted) {
//         return;
//       }
//
//       if (project != null) {
//         BlocProvider.of<ProjectCubit>(context).updateProject(project);
//       }
//     } catch (e) {
//       return;
//     }
//   }
//
//   Future<Project?> createProject(Project project) async {
//     await firestoreManager.createProject(project);
//   }
// }
