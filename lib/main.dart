import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

Image testImg = Image.asset('assets/avatars/test.jpg');
String username = "dertik";

const MaterialColor color1 = Colors.lightBlue;
const Color color2 = Colors.white;
//const MaterialColor color2 = Colors.blue;

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
