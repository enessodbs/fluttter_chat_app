import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? get currentUser => _auth.currentUser;

  //sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      });
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  //register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      });
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
