import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// ignore: unused_import
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show QuerySnapshot, QueryDocumentSnapshot;

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
        builder: (_) => AppWrapperProvider(),
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

class FlashcardSet {
  String name;
  String emoji;
  int bgColor;
  List<String> flashcards;
  FlashcardSet(
      String rname, String remoji, int rbgColor, List<String> rflashcards) {
    print("plsgggobject");
    this.name = rname;
    print("plsgggobject");
    this.emoji = remoji;
    print("plsgggobject");
    this.bgColor = rbgColor;
    print("plsgggobject");
    this.flashcards = rflashcards;
    print("plsgggobject");
  }
}

class AppWrapperProvider extends StatefulWidget {
  AppWrapperProvider({Key key}) : super(key: key);

  @override
  _AppWrapperProviderState createState() => _AppWrapperProviderState();
}

class _AppWrapperProviderState extends State<AppWrapperProvider> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FlangoUser>.value(
      value: _auth.authStateChange,
      child: Container(
        child: AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  AppWrapper({Key key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  var isInit = true;
  var loading = false;
  var newUser = true;

  String sgninEmail = '';
  String regEmail = '';
  String sgninPassword = '';
  String regPassword = '';

  final _sgninFormKey = GlobalKey<FormState>();
  final _regFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> _newSetKey;

  //aspect Ratio for grid view
  Widget _setCard(Map flashcardSet) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            width: 2,
            color: color1[300],
          ),
        ),
        child: InkWell(
          splashColor: Colors.lightBlue[200].withAlpha(100),
          onTap: () {},
          child: Container(
            //color: Colors.amber[300],
            height: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    //color: Colors.green[300],
                    height: 75,
                    color: Color(flashcardSet['bgColor']),
                    child: Center(
                      child: Text(
                        flashcardSet['emoji'],
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  //color: Colors.amber[50],
                  height: 50,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              //color: Colors.amber,
                              height: double.infinity,
                              width: constraints.maxWidth * 51 / 80,
                              child: Center(
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    flashcardSet['name'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              //color: Colors.amber,
                              height: double.infinity,
                              width: constraints.maxWidth * 7 / 20,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Cards:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      flashcardSet['flashcards']
                                          .length
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FlangoUser currentUser = Provider.of<FlangoUser>(context);

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
        : ((currentUser != null)
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
                          icon: Icon(Icons.archive),
                          child: Text("My Sets"),
                        ),
                        Tab(
                          icon: Icon(Icons.language),
                          child: Text("Flango's Sets"),
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
                      Stack(
                        children: [
                          StreamBuilder(
                            stream: DatabaseService(currentUser.uid)
                                .userSetsChangesStream(),
                            builder: (context, snapshot) {
                              QuerySnapshot flashcardSetList = snapshot.data;
                              List<QueryDocumentSnapshot> unFDocsList = [];
                              List<QueryDocumentSnapshot> docsList = [];
                              if (flashcardSetList != null) {
                                unFDocsList = flashcardSetList.docs;
                                //List<QueryDocumentSnapshot> docsList = [];
                                for (var indDocument in unFDocsList) {
                                  if (indDocument.data()['test'] != 'test') {
                                    docsList.add(indDocument);
                                  }
                                }
                              }
                              print("fgdgdrhdt ${docsList.length}");
                              print("fgdgdrhdt ${docsList.length == 0}");
                              return (docsList.length ==
                                      0) //flashcardSetList.docs.length == 1)
                                  ? LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Container(
                                          height: constraints.maxHeight,
                                          width: constraints.maxWidth,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: 15,
                                                  ),
                                                  child: Text(
                                                    "Nothing here now",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                Image.asset(
                                                  "assets/icons/empty_box.png",
                                                  width: constraints.maxWidth *
                                                      0.4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GridView.builder(
                                        itemCount: docsList.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          return _setCard(
                                            {
                                              'name': docsList[index].id,
                                              'emoji': docsList[index]
                                                  .data()['emoji'],
                                              'bgColor': docsList[index]
                                                  .data()['bgColor'],
                                              'flashcards': docsList[index]
                                                  .data()['flashcards'],
                                            },
                                          );
                                        },
                                      ),
                                    );
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: FloatingActionButton(
                                child: Icon(Icons.add),
                                onPressed: () {
                                  DatabaseService(currentUser.uid).updateSet(
                                    context,
                                    _newSetKey,
                                    setState,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder(
                        stream: DatabaseService(currentUser.uid)
                            .officialSetsChangesStream(),
                        builder: (context, snapshot) {
                          QuerySnapshot flashcardSetList = snapshot.data;

                          return (flashcardSetList == null)
                              ? LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      height: constraints.maxHeight,
                                      width: constraints.maxWidth,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 15,
                                              ),
                                              child: Text(
                                                "Nothing here now",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              "assets/icons/empty_box.png",
                                              width: constraints.maxWidth * 0.4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    itemCount: flashcardSetList.docs.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      return _setCard(
                                        {
                                          'name':
                                              flashcardSetList.docs[index].id,
                                          'emoji': flashcardSetList.docs[index]
                                              .data()['emoji'],
                                          'bgColor': flashcardSetList
                                              .docs[index]
                                              .data()['bgColor'],
                                          'flashcards': flashcardSetList
                                              .docs[index]
                                              .data()['flashcards'],
                                        },
                                      );
                                    },
                                  ),
                                );
                        },
                      ),
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
                                    child: Text("Sign Out"),
                                  )
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
                                    validator: (val) => val.length <= 8
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
                                dynamic result =
                                    await _auth.googleSignIn(isSignUp: false);
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
                                dynamic result =
                                    await _auth.facebookSignIn(isSignUp: false);
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
                                    validator: (val) => val.length <= 8
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
                                          regEmail,
                                          regPassword,
                                          sdcontext: context,
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
                                dynamic result = await _auth.googleSignIn(
                                  isSignUp: true,
                                  sdcontext: context,
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
                                dynamic result = await _auth.facebookSignIn(
                                  isSignUp: true,
                                  sdcontext: context,
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
