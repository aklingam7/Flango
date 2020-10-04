import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

Image testImg = Image.asset('assets/avatars/test.jpg'); //remove
String username = "dertik";

const MaterialColor color1 = Colors.lightBlue;
const Color color2 = Colors.white;
//const MaterialColor color2 = Colors.blue;

Route<dynamic> generateRoute(RouteSettings settings) {
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

  //final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flango'),
          backgroundColor: color1[200],
        ),
        bottomNavigationBar: Container(
          color: color1[200],
          padding: EdgeInsets.only(
            left: 9,
            right: 9,
            top: 7,
            bottom: 7,
          ),
          child: TabBar(
            indicator: BoxDecoration(
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
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Sets'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '5',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  Spacer(),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: testImg.image,
                        radius: 35.0,
                      ),
                      Spacer(),
                      FloatingActionButton(
                        heroTag: "btn1",
                        child: Icon(Icons.logout),
                        //width: 100,
                        onPressed: () => {},
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Column(
                      children: <Widget>[
                        Text(
                          username,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.topic),
              title: Text('My Sets'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              //leading: Icon(Icons.supervised_user_circle),
              title: Text('Find Sets'),
              onTap: () {
                // go to /explore
                Navigator.of(context).pushNamed('/explore');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // go to /settings
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'UN1',
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
  */
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ((int time) async {
      await Future.delayed(
        Duration(seconds: time),
        () {
          Navigator.of(context).pushNamed('/home');
        },
      );
    })(4);
    return Scaffold(
      backgroundColor: color2,
      body: Column(
        children: [
          Spacer(),
          Image.asset('assets/icons/high-res.png', width: 200),
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
              top: 5,
              left: 15,
              right: 15,
            ),
            child: Text(
              "Language on the Go! \nFlashcards Based Language Learning",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Spacer(),
          Container(
            height: 100,
            child: SpinKitSquareCircle(
              color: color1[200],
              size: 80.0,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
