import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a user object based on User
  //Users? _userFromFireBase(User user) {
    //return user != null ? Users(uid: user.uid) : null;
  //}

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // sign in by email & password
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }
    catch (e) {
      return null;
    }
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;



      return user;
    } catch (e) {
      return null;
    }
  }

  // register with email & password
  Future RegisterUser(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // create a new document for the user with uid
      await DatabaseService(uid: result.user!.uid).updateUserData(name, email);

      User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}