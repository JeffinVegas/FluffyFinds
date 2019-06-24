import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
//import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


void main() => runApp(MyApp());

class MapUtils {

  static openMap() async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=36.1085,-115.1432';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FluffyFinds',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('FluffyFinds Prototype'), centerTitle: true),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int s = 0;
  int min, max, r, t, b;
  Random rnd;
  String changetemp = "";
  String status = "off";
  String cond ="";

  void _changetemp() {
    setState(() {
      s++;
      min = 0;
      max = 2;
      rnd = new Random();
      r = min + rnd.nextInt(max - min);

    if(r == 1) {
      min = 70;
      max = 75;
      rnd = new Random();
      r = min + rnd.nextInt(max - min);
      //changetemp = r.toString();
    }
    else {
      min = 93;
      max = 98;
      rnd = new Random();
      r = min + rnd.nextInt(max - min);
      //changetemp = r.toString();
    }
    _collarstatus();
    });
  }

  void _collarstatus() {
    setState(() {
      if(r > 92) status = "on";
      else status = "off";
    });
  }

  void _inouthouse() {
    setState(() {
      //var now = new DateTime.now();
      //var formatter = new DateFormat('EEEE');
      //String formatted = formatter.format(now);
      //print(formatted);
      //Random rnd;
      min = 0;
      max = 10;
      rnd = new Random();
      t = min + rnd.nextInt(max - min);
      if(t % 2 == 0) cond = "OUTSIDE";
      else cond = "INSIDE";
    });
  }

  void _batterystatus() {
    setState(() {
      min = 0;
      max = 9;
      rnd = new Random();
      b = min + rnd.nextInt(max-min);
      b = b * 12;
      //String warning = "";
      //if(r <= 12) warning = " CHARGE BATTERY!!!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
    elevation: 10.0,
    child: ListView(
      children: <Widget>[
        Card(
          elevation: 10.0,
          child: ListTile(            
            leading: Icon(Icons.wb_sunny),
            title: Row(
              children: [
                Expanded(
                  child: Text("Temperature"),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffddddff),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(r.toString()),
                ),
                ],
            ),
            onTap: _changetemp,
          ),
        ),
        Card(
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.pets),
            title: Row(
              children: [
                Expanded(
                  child: Text("Collar Status"),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffddddff),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(status),
                ),
                ],
            ),
            //onTap would go here
          ),
          ),
        Card(
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.home),
             title: Row(
              children: [
                Expanded(
                  child: Text("Inside the House?"),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffddddff),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(cond),
                ),
                ],
            ),
            onTap: _inouthouse,
          ),
        ),
        Card(
          borderOnForeground: false,
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.battery_charging_full),
            title: Row(
              children: [
                Expanded(
                  child: Text("Check Collar Battery"),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffddddff),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text("$b%"),
                ),
                ],
            ),
            onTap: _batterystatus,
          ),
        ),
        Card(
          color: Colors.redAccent[100],
          borderOnForeground: false,
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Firebase Test'),
            onTap: () {
              Firestore.instance.collection('mountains').document()
              .setData({ 'title': 'Mountain', 'author': 'Dad' });
              final snackBar = SnackBar(content: Text("hi"));
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        ),
        Card(
          color: Colors.lightBlueAccent[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.map),
            title: Text('GPS'),
            onTap: () async {
              //print('Working on it...');
              /*const url = 'https://maps.google.com';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }*/
              MapUtils.openMap();
              final snackBar = SnackBar(content: Text("Working on it..."));
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      ],
    ),
  );
}
}