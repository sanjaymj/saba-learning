import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:sabalearning/models/user.dart' as myUser;
import 'package:sabalearning/services/firestore-database.service.dart';

class FirebaseAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  myUser.User _createUserFromFirebaseUser(auth.User user) {
    return user != null
        ? new myUser.User(user.uid, user.photoURL, user.displayName)
        : null;
  }

  Stream<myUser.User> get user {
    return _auth
        .userChanges()
        .map((auth.User user) => _createUserFromFirebaseUser(user));
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password,
      String displayName, String source, String target) async {
    try {
      auth.UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _auth.currentUser
          .updateProfile(displayName: displayName, photoURL: "");
      FirestoreDatabaseService()
          .addLanguagePairCollectionToFirestore(user.user.uid, source, target);
      return _createUserFromFirebaseUser(user.user);
    } catch (e) {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _createUserFromFirebaseUser(user.user);
    } catch (e) {
      return null;
    }
  }

  Future updateUserPersonalInfo(myUser.User user) async {
    try {
      await _auth.currentUser.updateProfile(
          displayName: user.displayName, photoURL: user.avatarUrl);
      return _createUserFromFirebaseUser(_auth.currentUser);
    } catch (e) {
      return null;
    }
  }

  Future resetPassword(String emailAddress) async {
    try {
      return await _auth.sendPasswordResetEmail(email: emailAddress);
    } catch (e) {
      throw e;
    }
  }
}
