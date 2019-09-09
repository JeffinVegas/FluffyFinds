import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
//import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
//ADDED
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
part 'petA.dart';
part 'petB.dart';



class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Pet 1'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _PetA()),
                );
              },
            ),
            RaisedButton(
              child: Text('Pet 2'),
              onPressed: () {
               
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => _PetB()),
                );
              },
            ),
          ],
        ),        
      ),
    );
  }
}

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