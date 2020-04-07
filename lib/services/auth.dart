import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFBUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return _userFromFBUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFBUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String firstName, String lastName, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = _userFromFBUser(result.user);
      if (user != null) {
        print(firstName);
        print(lastName);
        user = User(
            uid: result.user.uid,
            firstName: firstName,
            lastName: lastName,
            isAdmin: false,
            isModerator: false,
            hasBeenUpdated: false);
      }
      await DatabaseService(uid: user.uid).updateUserData(user);

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  User _userFromFBUser(FirebaseUser user) {
    return user != null ? _databaseService.getUserByID(user.uid) : null;
  }
}
