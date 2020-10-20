import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:flango/main.dart' show FlangoUser, color1;
import 'package:flango/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future _welcomeUser(BuildContext sdcontext, String uid) async {
    print("plsworkpls");
    showDialog(
      context: sdcontext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _WelcomeDialog(
          uid: uid,
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

  String heroTagGenerator() {
    return Random().nextDouble().toString();
  }

  //Todo: Add Sign in with Anon

  Future signInWithEmailAndPassword(String email, String password,
      {BuildContext sdcontext}) async {
    try {
      var toReturn = FlangoUser(
        //uid: (await _auth.signInWithEmailAndPassword(email: null, password: null,))
        uid: (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user
            .uid,
      );
      print(await DatabaseService(toReturn.uid).getLang());
      if (!["es", "fr", "hi"].contains(
        await DatabaseService(toReturn.uid).getLang(),
      )) {
        await _welcomeUser(sdcontext, toReturn.uid);
      }
      return toReturn;
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
      print(await DatabaseService(toReturn.uid).getLang());
      print(!["es", "fr", "hi"].contains(
        await DatabaseService(toReturn.uid).getLang(),
      ));
      if (!["es", "fr", "hi"].contains(
        await DatabaseService(toReturn.uid).getLang(),
      )) {
        await _welcomeUser(sdcontext, toReturn.uid);
      }
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
      print(await DatabaseService(toReturn.uid).getLang());
      print(!["es", "fr", "hi"].contains(
        await DatabaseService(toReturn.uid).getLang(),
      ));
      if (!["es", "fr", "hi"].contains(
        await DatabaseService(toReturn.uid).getLang(),
      )) {
        await _welcomeUser(sdcontext, toReturn.uid);
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

          print(await DatabaseService(toReturn.uid).getLang());
          if (!["es", "fr", "hi"].contains(
            await DatabaseService(toReturn.uid).getLang(),
          )) {
            await _welcomeUser(sdcontext, toReturn.uid);
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

class _WelcomeDialog extends StatefulWidget {
  final String uid;
  _WelcomeDialog({Key key, this.uid}) : super(key: key);

  @override
  _WelcomeDialogState createState() => _WelcomeDialogState(uid: uid);
}

class _WelcomeDialogState extends State<_WelcomeDialog> {
  final String uid;

  _WelcomeDialogState({this.uid});

  bool introduction = true;
  String selection = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        (introduction)
            ? "Welcome to Flango"
            : "Select the language you want to learn:",
      ),
      content: (introduction)
          ? Text(
              "Flango is a mobile application that helps you improve your second language vocabulary. It makes it extremely easy to create Sets of Flashcards for a list of related English words and sync them between multiple devices. If you don't want to make your own sets, new Official Sets are published weekly. With the easy to use testing and practice modes, you can build up your vocabulary in no time!",
            )
          : SizedBox(
              width: 240,
              height: 260,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                              child: Card(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 13.0),
                                        child: Image.asset(
                                          'assets/flags/Spain.png',
                                          width: 60,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13.0),
                                        child: Text(
                                          "Spanish",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                          right: 4.0,
                                        ),
                                        child: (selection != "es")
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  shape: BoxShape.circle,
                                                ),
                                                width: 15,
                                                height: 15,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    shape: BoxShape.circle,
                                                    color: color1[200]),
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: (selection != "es")
                                  ? () => setState(() {
                                        selection = "es";
                                      })
                                  : () => setState(() {
                                        selection = "";
                                      }),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                              child: Card(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 13.0),
                                        child: Image.asset(
                                          'assets/flags/France.png',
                                          width: 60,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13.0),
                                        child: Text(
                                          "French",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                          right: 4.0,
                                        ),
                                        child: (selection != "fr")
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  shape: BoxShape.circle,
                                                ),
                                                width: 15,
                                                height: 15,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    shape: BoxShape.circle,
                                                    color: color1[200]),
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: (selection != "fr")
                                  ? () => setState(() {
                                        selection = "fr";
                                      })
                                  : () => setState(() {
                                        selection = "";
                                      }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                              child: Card(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 13.0),
                                        child: Image.asset(
                                          'assets/flags/India.png',
                                          width: 60,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13.0),
                                        child: Text(
                                          "Hindi",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                          right: 4.0,
                                        ),
                                        child: (selection != "hi")
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  shape: BoxShape.circle,
                                                ),
                                                width: 15,
                                                height: 15,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    shape: BoxShape.circle,
                                                    color: color1[200]),
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: (selection != "hi")
                                  ? () => setState(() {
                                        selection = "hi";
                                      })
                                  : () => setState(() {
                                        selection = "";
                                      }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      actions: (introduction)
          ? <Widget>[
              FlatButton(
                child: Text("Next"),
                onPressed: () {
                  setState(() {
                    introduction = false;
                  });
                },
              ),
            ]
          : <Widget>[
              FlatButton(
                child: Text("Back"),
                onPressed: () {
                  setState(() {
                    introduction = true;
                  });
                },
              ),
              FlatButton(
                child: Text("Finish"),
                onPressed: () async {
                  if (["es", "fr", "hi"].contains(selection)) {
                    try {
                      await DatabaseService(uid)
                          .initializeCollection(selection);
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
            ],
    );
  }
}
