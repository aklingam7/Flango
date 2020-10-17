import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// ignore: unused_import
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flango/services/auth.dart';
import 'package:flango/services/database.dart';

FirebaseAnalytics analytics;

void main() {
  runApp(MyApp());
}

const MaterialColor color1 = Colors.lightBlue;
const Color color2 = Colors.white;
//const MaterialColor color2 = Colors.blue;

Route<dynamic> generateRoute(RouteSettings settings) {
  // ignore: unused_local_variable
  final args = settings.arguments;

  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => SplashScreen());
    case '/app':
      return MaterialPageRoute(
        builder: (_) => AppWrapper(),
      );

    default:
      return MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR'),
          ),
        );
      });
  }
}

final AuthService _auth = AuthService();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flango',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: color1,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: generateRoute,
    );
  }
}

class FlangoUser {
  final String uid;

  FlangoUser({this.uid});
}

class AppWrapper extends StatefulWidget {
  AppWrapper({Key key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  var isInit = true;
  var displayHome = false;
  var loading = false;
  var newUser = true;

  FlangoUser currentUser;

  String sgninEmail = '';
  String regEmail = '';
  String sgninPassword = '';
  String regPassword = '';

  final _sgninFormKey = GlobalKey<FormState>();
  final _regFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (isInit) {
      isInit = false;

      Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          Future<bool> internetLost() async {
            return !((await (Connectivity().checkConnectivity())) ==
                    (await (Connectivity().checkConnectivity()))) ||
                ((await (Connectivity().checkConnectivity())) ==
                    ConnectivityResult.none);
          }

          if (await internetLost()) {
            () async {
              while (await internetLost()) {
                await Future.delayed(
                  Duration(milliseconds: 1300),
                  () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("No Internet Conection"),
                          content: Text(
                            "An internet connection is required to use Flango.",
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Retry"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }
            }();
          }
        },
      );

      _auth.authStateChange.listen(
        (event) {
          if (event != null) {
            setState(() => displayHome = true);
          } else {
            setState(() => displayHome = false);
          }
          currentUser = event;
        },
      );

      setState(() => displayHome = false);

      Future.delayed(
        Duration(milliseconds: 100),
        () => setState(() => displayHome = false),
      );
    }

    return loading
        ? Container(
            color: Colors.white,
            child: Center(
              child: SpinKitChasingDots(
                color: color1[100],
                size: 100.0,
              ),
            ),
          )
        : (displayHome
            ? DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    title: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Flango",
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: color1[200],
                  ),
                  bottomNavigationBar: Container(
                    color: color1[200],
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 8,
                      bottom: 8,
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                        border: Border.all(
                          color: Colors.transparent,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: color1[300],
                      ),
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.topic),
                          child: Text("My Sets"),
                        ),
                        Tab(
                          icon: Icon(Icons.language),
                          child: Text("Explore"),
                        ),
                        Tab(
                          icon: Icon(Icons.settings),
                          child: Text("Settings"),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Icon(Icons.directions_car_sharp),
                      Icon(Icons.directions_transit),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_bike),
                                  FlatButton(
                                      onPressed: () async {
                                        setState(() => loading = true);
                                        await _auth.signOut();
                                        setState(() => loading = false);
                                      },
                                      child: Text("Sign Out"))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Flango",
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: color1[200],
                  ),
                  bottomNavigationBar: Container(
                    color: color1[200],
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 8,
                      bottom: 8,
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                        border: Border.all(
                          color: Colors.transparent,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: color1[300],
                      ),
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.login),
                          child: Text("Sign In"),
                        ),
                        Tab(
                          icon: Icon(Icons.person_add_alt_1_outlined),
                          child: Text("Sign Up"),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 15,
                              left: 25,
                              right: 25,
                            ),
                            child: Text(
                              "Sign In to Flango to access your Flashcards",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Form(
                            key: _sgninFormKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 15,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: TextFormField(
                                    obscureText: false,
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an email' : null,
                                    onChanged: (val) {
                                      setState(() => sgninEmail = val);
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.mail),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Email',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 13,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (val) => val.length < 8
                                        ? 'Passwords are 8+ characters long'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => sgninPassword = val);
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.vpn_key),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Password',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 13,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.black54,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.mail,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Sign In with Email",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_sgninFormKey.currentState
                                          .validate()) {
                                        newUser = false;
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                          sgninEmail,
                                          sgninPassword,
                                        );
                                        setState(() => loading = false);
                                        if (result == null) {
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Error"),
                                                content: Text(
                                                  "Could not sign in with those credentials. Please recheck your email and password fields.",
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("Okay"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 25,
                              right: 25,
                            ),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                            ),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.red[500],
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        const IconData(
                                          0xe800,
                                          fontFamily: 'GoogleIcon',
                                          fontPackage: null,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Sign In with Google",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                newUser = false;
                                setState(() => loading = true);
                                dynamic result = await _auth.googleSignIn();
                                setState(() => loading = false);
                                if (result == null) {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                          "Failed to sign in with Google.",
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
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 25,
                              right: 25,
                            ),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue[700],
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        const IconData(
                                          0xe800,
                                          fontFamily: 'FacebookIcon',
                                          fontPackage: null,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Sign In with Facebook",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                newUser = false;
                                setState(() => loading = true);
                                dynamic result = await _auth.facebookSignIn();
                                setState(() => loading = false);
                                if (result == null) {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                          "Failed to sign in with Facebook.",
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
                              },
                            ),
                          ),
                        ],
                      ),
                      ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 15,
                              left: 25,
                              right: 25,
                            ),
                            child: Text(
                              "Sign Up for Flango to start learning",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Form(
                            key: _regFormKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 15,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: TextFormField(
                                    obscureText: false,
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an email' : null,
                                    onChanged: (val) {
                                      setState(() => regEmail = val);
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.mail),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Email',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 13,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (val) => val.length < 8
                                        ? 'Enter a password 8+ chars long'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => regPassword = val);
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.vpn_key),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Password',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 13,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (val) => val != regPassword
                                        ? 'Both passwords don\'t match'
                                        : null,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.vpn_key),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: 'Renter Password',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 13,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.black54,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.mail,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Sign Up with Email",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_regFormKey.currentState.validate()) {
                                        newUser = true;
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .registerWithEmailAndPassword(
                                                regEmail, regPassword);
                                        setState(() => loading = false);
                                        if (result == null) {
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Error"),
                                                content: Text(
                                                  "Could not sign up. Please supply a valid email.",
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("Okay"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 25,
                              right: 25,
                            ),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                            ),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.red[500],
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        const IconData(
                                          0xe800,
                                          fontFamily: 'GoogleIcon',
                                          fontPackage: null,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Sign Up with Google",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                newUser = true;
                                setState(() => loading = true);
                                dynamic result = await _auth.googleSignIn();
                                setState(() => loading = false);
                                if (result == null) {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                          "Failed to sign up with Google.",
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
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 25,
                              right: 25,
                            ),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue[700],
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        const IconData(
                                          0xe800,
                                          fontFamily: 'FacebookIcon',
                                          fontPackage: null,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Sign Up with Facebook",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                newUser = true;
                                setState(() => loading = true);
                                dynamic result = await _auth.facebookSignIn();
                                setState(() => loading = false);
                                if (result == null) {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                          "Failed to sign up with Facebook.",
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
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ((int delayTime) async {
      bool everythingWorking;
      while (!(everythingWorking ?? false)) {
        everythingWorking = true;
        await Future.delayed(
          Duration(seconds: delayTime),
          () async {
            await Connectivity().checkConnectivity().then(
              (value) async {
                if (value == ConnectivityResult.none) {
                  everythingWorking = false;
                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("No Internet Conection"),
                        content: Text(
                            "An internet connection is required to use Flango."),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Retry"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  await Firebase.initializeApp().then(
                    (value) async {
                      analytics = FirebaseAnalytics();
                      if (kDebugMode) {
                        await FirebaseCrashlytics.instance
                            .setCrashlyticsCollectionEnabled(false)
                            .then(
                          (value) {
                            FlutterError.onError =
                                FirebaseCrashlytics.instance.recordFlutterError;
                            Navigator.of(context).pushReplacementNamed('/app');
                          },
                          onError: (error) async {
                            print(error);
                            everythingWorking = false;
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Crashlytics Error"),
                                  content: Text("An error occured"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Retry"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      } else {
                        await FirebaseCrashlytics.instance
                            .setCrashlyticsCollectionEnabled(true)
                            .then(
                          (value) {
                            FlutterError.onError =
                                FirebaseCrashlytics.instance.recordFlutterError;

                            Navigator.of(context).pushReplacementNamed('/app');
                          },
                          onError: (error) async {
                            everythingWorking = false;
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Crashlytics Error"),
                                  content: Text("An error occured"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Retry"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    onError: (error) async {
                      print(error);
                      everythingWorking = false;
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Initialization Error"),
                            content: Text("Error with Initialization"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Retry"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        );
      }
    })(3);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color2,
        body: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            Image.asset(
              'assets/icons/high-res.png',
              width:
                  (MediaQuery.of(context).size.height * 0.25).ceil().toDouble(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Text(
                "Flango",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 25,
                right: 25,
              ),
              child: Text(
                "Flashcards Based Language Learning",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
            Container(
              height:
                  (MediaQuery.of(context).size.height * 0.11).ceil().toDouble(),
              child: SpinKitSquareCircle(
                color: color1[200],
                size: (MediaQuery.of(context).size.height * 0.09)
                    .ceil()
                    .toDouble(),
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
