import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //create user with user ID
  Future<void>? createUser({uid, firstName, lastName, email}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users
        .doc(uid)
        .set({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        })
        .then((value) => print('userAdded'))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
