import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

int min, max, r;
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FluffyFinds',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('FluffyFinds Prototype'), centerTitle: true),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  return Card(
    elevation: 10.0,
    child: ListView(
      children: <Widget>[
        Card(
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.wb_sunny),
            title: Text('Temperature'),
            onTap: () {
              //print('The temperature is...');

              Random rnd;
              String changetemp;
              min = 0;
              max = 2;
              rnd = new Random();
              r = min + rnd.nextInt(max - min);

              if(r == 1) {
              min = 70;
              max = 75;
              rnd = new Random();
              r = min + rnd.nextInt(max - min);
              changetemp = r.toString();
              }
              else {
              min = 93;
              max = 98;
              rnd = new Random();
              r = min + rnd.nextInt(max - min);
              changetemp = r.toString();
              }

              final snackBar = SnackBar(content: Text("The temperature is " + changetemp + "F."));
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        ),
        Card(
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.pets),
            title: Text('Collar Status'),
            onTap: () {
              String status = "off";
              if(r > 92) status = "on";
              else status = "off";
              final snackBar = SnackBar(content: Text("The collar is " + status + "."));
              Scaffold.of(context).showSnackBar(snackBar);
            },
            
          ),
          ),
        Card(
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.home),
            title: Text('Inside the House?'),
            onTap: () {
              var now = new DateTime.now();
              var formatter = new DateFormat('EEEE');
              String formatted = formatter.format(now);
              print(formatted);
              Random rnd;
              min = 0;
              max = 10;
              rnd = new Random();
              r = min + rnd.nextInt(max - min);
              String cond;
              if(r % 2 == 0) cond = "OUTSIDE";
              else cond = "INSIDE";
              final snackBar = SnackBar(content: Text(formatted + " is " + cond + "!"));
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        ),
        Card(
          borderOnForeground: false,
          elevation: 10.0,
          child: ListTile(
            leading: Icon(Icons.battery_charging_full),
            title: Text('Check Collar Battery'),
            onTap: () {
              Random rnd;
              min = 0;
              max = 9;
              rnd = new Random();
              int r = min + rnd.nextInt(max-min);
              r = r * 12;

              String changetemp = r.toString();
              String warning = "";
              if(r <= 12) warning = " CHARGE BATTERY!!!";
              final snackBar = SnackBar(content: Text(changetemp + "%" + warning));
              Scaffold.of(context).showSnackBar(snackBar);
            },
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