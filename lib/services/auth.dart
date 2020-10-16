import 'package:firebase_auth/firebase_auth.dart';

import 'package:flango/main.dart' show FlangoUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FlangoUser> get authStateChange {
    return _auth.authStateChanges().map(
      (event) {
        return event != null ? FlangoUser(uid: event.uid) : null;
      },
    );
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      return new FlangoUser(
        //uid: (await _auth.signInWithEmailAndPassword(email: null, password: null,))
        uid: (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user
            .uid,
      );
    } catch (e) {
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      return new FlangoUser(
        uid: (await _auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user
            .uid,
      );
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw ("Auth Service Email Sign In Exception: <${e.toString()}>");
    }
  }
}
