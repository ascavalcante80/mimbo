import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/users.dart';

class FirestoreManager {
  final FirebaseFirestore firestore;
  late final String userId;

  late CollectionReference users;
  late CollectionReference items;
  late CollectionReference reactions;
  late CollectionReference usernames;
  late CollectionReference userCreatedItems;
  final String reactionPerformedCollectionName = 'reactions_performed';

  FirestoreManager({required this.userId, required this.firestore}) {
    users = firestore.collection('users');
    items = firestore.collection('items');
    reactions = firestore.collection('reactions');
    usernames = firestore.collection('usernames');
    userCreatedItems = users.doc(userId).collection('created_items');
  }

  FirestoreManager.noUserId({required this.firestore}) {
    users = firestore.collection('users');
    items = firestore.collection('items');
    reactions = firestore.collection('reactions');
    usernames = firestore.collection('usernames');
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
    await users.where('username', isEqualTo: user.username).get().then((value) {
      if (value.docs.isNotEmpty) {
        throw UsernameAlreadyExistsException();
      }
    });
    // converts created_at to a server timestamp
    Map<String, dynamic> userJson = user.toJson();
    userJson['created_at'] = FieldValue.serverTimestamp();
    await users.doc(user.id).set(userJson);
  }

//
// Future<void> createUser(GnomeeUser user) async {
//   /// The [createUser] method is a method that creates a new [GnomeeUser] in the
//   /// Firestore database. It uses the UUID of the user as the document ID.
//   ///
//
//   DocumentReference userDoc = users.doc(user.id);
//
//   await userDoc.get().then((value) {
//     if (value.exists) {
//       throw IDAlreadyExistsException();
//     }
//   });
//
//   await users.where('username', isEqualTo: user.username).get().then((value) {
//     if (value.docs.isNotEmpty) {
//       throw UsernameAlreadyExistsException();
//     }
//   });
//   await users.doc(user.id).set(user.toJson());
// }
}

class IDAlreadyExistsException implements Exception {
  String errorMessage() => 'A user with this ID already exists';
}

class UsernameAlreadyExistsException implements Exception {
  String errorMessage() => 'A user with this username already exists';
}
