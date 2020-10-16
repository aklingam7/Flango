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
    case '/home':
      return MaterialPageRoute(
        builder: (_) => HomePage(),
      );
    case '/login':
      return MaterialPageRoute(
        builder: (_) => HomePage(),
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

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
                },
              );
            }
          }();
        }
      },
    );
    return DefaultTabController(
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
                        FlatButton(onPressed: null, child: Text("Sign Out"))
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
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
                            Navigator.of(context).pushReplacementNamed('/home');
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
                            Navigator.of(context).pushReplacementNamed('/home');
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
