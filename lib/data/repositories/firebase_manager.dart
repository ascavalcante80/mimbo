import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mimbo/data/models/credits.dart';
import 'package:mimbo/data/models/feedback_form.dart';
import 'package:mimbo/data/models/projects.dart';

import '../models/users.dart';

class FirestoreManager {
  final FirebaseFirestore firestore;
  late final String userId;

  late CollectionReference users;
  late CollectionReference projects;
  late CollectionReference credits;
  String feedbacksForms = 'feedbacks_forms';
  String feedbackProvided = 'feedback_provided';

  FirestoreManager({required this.userId, required this.firestore}) {
    users = firestore.collection('users');
    projects = firestore.collection('projects');
    credits = firestore.collection('credits');
  }

  FirestoreManager.noUserId({required this.firestore}) {
    users = firestore.collection('users');
    projects = firestore.collection('projects');
    credits = firestore.collection('credits');
  }

  Future<MimUser?> getUserByID(String id) async {
    /// The [getUserByID] method is a method that searches for a [MimUser] in
    /// the Firestore database by its ID. It returns the [MimUser] if it
    /// exists, otherwise it returns null.

    MimUser? mimUser;
    await users.doc(id).get().then((value) {
      if (value.exists) {
        mimUser = MimUser.fromDocumentSnapshot(value);
      }
    });
    return mimUser;
  }

  Future<void> createUser(MimUser user) async {
    /// The [createUser] method is a method that creates a new [MimUser] in the
    /// Firestore database. It uses the UUID of the user as the document ID.
    ///
    DocumentReference userDoc = users.doc(user.id);
    await userDoc.get().then((value) {
      if (value.exists) {
        throw IDAlreadyExistsException();
      }
    });

    // checks if the username already exists
    await checkUsername(user.username);

    // converts created_at to a server timestamp
    Map<String, dynamic> userJson = user.toJson();
    userJson['created_at'] = FieldValue.serverTimestamp();
    await users.doc(user.id).set(userJson);
  }

  Future<void> updateUser(MimUser user) async {
    /// The [updateUser] method is a method that updates a [MimUser] in the
    /// Firestore database. It uses the UUID of the user as the document ID.

    // checks if the username already exists
    await checkUsername(user.username);

    await users.doc(user.id).update(user.toJson());
  }

  Future<void> checkUsername(String username) async {
    /// The [checkUsername] method is a method that checks if a username already
    /// exists in the Firestore database. It throws an exception if the username
    /// already exists.
    await users.where('username', isEqualTo: username).get().then((value) {
      if (value.docs.isNotEmpty) {
        throw UsernameAlreadyExistsException();
      }
    });
  }

  Future<void> deleteUser(MimUser user) async {
    /// The [deleteUser] method is a method that deletes a [MimUser] in the
    /// Firestore database. It uses the UUID of the user as the document ID.

    // to be handle by cloud function -> to delete all projects, tests, etc
  }

  Future<String?> createProject(Project project) async {
    /// The [createProject] method is a method that creates a new [Project] in
    /// the Firestore database. It uses the UUID of the project as the document
    /// ID.
    String? id;
    await projects.add(project.toJson()).then((onValue) {
      id = onValue.id;
    });
    return id;
  }

  Future<Project?> getProjectByID(String id) async {
    /// The [getProjectByID] method is a method that searches for a [Project] in
    /// the Firestore database by its ID. It returns the [Project] if it
    /// exists, otherwise it returns null.

    Project? project;
    await projects.doc(id).get().then((value) {
      if (value.exists) {
        project = Project.fromDocumentSnapshot(value);
      }
    });
    return project;
  }

  Future<void> updateProject(Project project) async {
    /// The [updateProject] method is a method that updates a [Project] in the
    /// Firestore database. It uses the UUID of the project as the document
    /// ID.
    await projects.doc(project.id).update(project.toJson());
  }

  Future<void> deleteProject(String id) async {
    /// The [deleteProject] method is a method that deletes a [Project] in the
    /// Firestore database. It uses the UUID of the project as the document
    /// ID.
    await projects.doc(id).delete();

    // to be handle by cloud function -> to delete all tests, etc
  }

  Future<String?> createCredit(MimCredit credit) async {
    /// The [createCredit] method is a method that creates a new [Credit] in
    /// the Firestore database. It uses the UUID of the credit as the document
    /// ID.
    String? id;
    // TODO to be replaced by a Cloud Function
    await credits.add(credit.toJson()).then((onValue) {
      id = onValue.id;
    });
    return id;
  }

  Future<void> updateCredit(MimCredit credit) async {
    /// The [updateCredit] method is a method that updates a [Credit] in the
    /// Firestore database. It uses the UUID of the credit as the document
    /// ID.
    await credits.doc(credit.id).update(credit.toJson());
  }

  Future<MimCredit?> getCreditByID(String id) async {
    MimCredit? credit;
    await credits.doc(id).get().then((value) {
      if (value.exists) {
        credit = MimCredit.fromDocumentSnapshot(value);
      }
    });
    return credit;
  }

  Future<String?> createFormFeedback(FormFeedback formFeedback) async {
    /// The [createFormFeedback] method is a method that creates a new
    /// [FormFeedback] in the project database. It also creates a redundant
    /// data in the user's feedbacks_forms collection.
    String? id;

    await projects
        .doc(formFeedback.projectId)
        .collection(feedbacksForms)
        .add(formFeedback.toJson())
        .then((onValue) {
      id = onValue.id;
    });

    // adds redundant data to the user's feedbacks_forms collection
    await users
        .doc(userId)
        .collection(feedbackProvided)
        .add({'form_id': id, 'project_id': formFeedback.projectId});

    return id.toString();
  }

  Future<FormFeedback?> getFormFeedbackByID(
      String projectId, String formId) async {

    FormFeedback? formFeedback;
    await projects
        .doc(projectId)
        .collection(feedbacksForms)
        .doc(formId)
        .get()
        .then((value) {
      if (value.exists) {
        formFeedback = FormFeedback.fromDocumentSnapshot(value);
      }
    });
    return formFeedback;
  }

  Future<List<FormFeedback>> getFormFeedbacksByProjectID(String projectId) async {
    List<FormFeedback> formFeedbacks = [];
    await projects.doc(projectId).collection(feedbacksForms).get().then((value) {
      for (var element in value.docs) {
        formFeedbacks.add(FormFeedback.fromDocumentSnapshot(element));
      }
    });
    return formFeedbacks;
  }

}

class IDAlreadyExistsException implements Exception {
  String errorMessage() => 'A user with this ID already exists';
}

class UsernameAlreadyExistsException implements Exception {
  String errorMessage() => 'A user with this username already exists';
}
