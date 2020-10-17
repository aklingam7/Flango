import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:flango/main.dart' show FlangoUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  void _welcomeUser(BuildContext sdcontext) {
    showDialog(
      context: sdcontext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Welcome to Flango"),
          content: Text(
            "Flango is a flashcards based language learning mobile application.",
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

  Future registerWithEmailAndPassword(String email, String password,
      {BuildContext sdcontext}) async {
    try {
      var toReturn = FlangoUser(
        uid: (await _auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user
            .uid,
      );
      _welcomeUser(sdcontext);
      return toReturn;
    } catch (e) {
      return null;
    }
  }

  Future googleSignIn({
    @required bool isSignUp,
    BuildContext sdcontext,
  }) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var toReturn = FlangoUser(
        uid: (await _auth.signInWithCredential(
          googleAuthCredential,
        ))
            .user
            .uid,
      );
      if (isSignUp) {
        _welcomeUser(sdcontext);
      }
      return toReturn;
    } catch (e) {
      return null;
    }
  }

  Future facebookSignIn({
    @required bool isSignUp,
    BuildContext sdcontext,
  }) async {
    try {
      final FacebookLoginResult facebookLoginResult =
          await _facebookLogin.logIn(['email']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(
                  facebookLoginResult.accessToken.token);
          var toReturn = FlangoUser(
            uid: (await _auth.signInWithCredential(
              facebookAuthCredential,
            ))
                .user
                .uid,
          );
          if (isSignUp) {
            _welcomeUser(sdcontext);
          }
          return toReturn;
          break;
        case FacebookLoginStatus.cancelledByUser:
          throw ("User cancelled Facebook login");
        case FacebookLoginStatus.error:
          throw (facebookLoginResult.errorMessage);
      }
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
