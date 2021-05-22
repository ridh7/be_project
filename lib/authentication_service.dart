import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Signed Out";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(
      {String email, String password, String name, String phone}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseAuth.instance.currentUser.updateProfile(displayName: name);
      FirebaseFirestore.instance.collection("users").add({
        "phone": phone,
      }).then((value) {
        print(value.id);
      });
      signOut();
      return "User Created";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
