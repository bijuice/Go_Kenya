import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_kenya/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// service for making authentication requests to Firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get current user

  Future<String> getCurrentUser() async {
    final User? user = _auth.currentUser;

    return user!.uid;
  }

  //create user obj based on FirebaseUser
  CustomUser? _userFromFirebase(dynamic user) {
    return user != FirebaseException ? CustomUser(uid: user.user.uid) : null;
  }

  //auth change user stream
  Stream<User?> onAuthChange() {
    return _auth.authStateChanges();
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return _userFromFirebase(userCredential);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  //register with email and password
  Future createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
  }

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

  //sign out
  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
