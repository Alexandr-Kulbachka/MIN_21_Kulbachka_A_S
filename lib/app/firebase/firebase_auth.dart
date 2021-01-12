import 'package:firebase_auth/firebase_auth.dart';
import '../services/account_service.dart';
import 'package:HelpHere/models/user.dart' as appUser;

class FBAuth {
  FirebaseAuth _auth;

  User get currentUser => _auth.currentUser;

  FBAuth._constructor() {
    _auth = FirebaseAuth.instance;
  }

  static FBAuth _instance;

  static FBAuth getInstance() {
    if (_instance == null) {
      _instance = FBAuth._constructor();
    }
    return _instance;
  }

  Future<dynamic> register(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (exception) {
      return exception;
    }
    return userCredential.user.uid;
  }

  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (exception) {
      return exception;
    }
    return userCredential.user.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<dynamic> changeEmail(
      String oldEmail, String password, String newEmail) async {
    try {
      await _auth.currentUser
          .reauthenticateWithCredential(
              EmailAuthProvider.credential(email: oldEmail, password: password))
          .then((value) async {
        await _auth.currentUser.updateEmail(newEmail);
      });
    } catch (exception) {
      return exception;
    }
    return true;
  }

  Future<bool> deleteAccount() async {
    try {
      await _auth.currentUser.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> changePassword(
      String oldEmail, String password, String newPassword) async {
    try {
      await _auth.currentUser
          .reauthenticateWithCredential(
              EmailAuthProvider.credential(email: oldEmail, password: password))
          .then((value) async {
        await _auth.currentUser.updatePassword(newPassword);
      });
    } catch (exception) {
      return exception;
    }
    return true;
  }
}
