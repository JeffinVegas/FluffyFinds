import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
part 'petA.dart';
part 'petB.dart';


class Pet {
  int battery;
  String house;
  String name;
  int temperature;
  double latitudes;
  double longtitudes;

  Pet(this.battery, this.house, this.name, this.temperature, this.latitudes, this.longtitudes);

  Pet.fromSnapshot(DataSnapshot snapshot):
    battery = snapshot.value["battery"],
    house = snapshot.value["house"],
    name = snapshot.value['name'],
    temperature = snapshot.value["temperature"],
    latitudes = snapshot.value["latitude"],
    longtitudes = snapshot.value["longtitude"];

  toJson() {
    return {
      "battery": battery,
      "house": house,
      "name": name,
      "temperature": temperature,
      "latitude": latitudes,
      "longtitude": longtitudes,
    };
  } 

}


class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home>  {
  

  var i;
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    _getThingsOnStartup();
    super.initState();
  }

  Future _getThingsOnStartup() async {
    _changeInfo();
  }

  void _changeInfo() {
    setState(() async {
    await ref.child("petA/name").once().then((DataSnapshot dataSnap){
      i = dataSnap.value;
    });

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: FutureBuilder(
                future: FirebaseDatabase.instance.reference().child('petA').once(),
                builder:(context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if(snapshot.hasError){
                        return new Center(child: Text('Error: ${snapshot.error}'));
                      }
                      else {
                        Pet petA = Pet.fromSnapshot(snapshot.data);
                        return RaisedButton(
                          child: Text(petA.name),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => _PetA()));
                          }
                        );
                      }
                  }
                }
              ),
            ),
            Container(
              child: FutureBuilder(
                future: FirebaseDatabase.instance.reference().child('petB').once(),
                builder:(context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if(snapshot.hasError){
                        return new Center(child: Text('Error: ${snapshot.error}'));
                      }
                      else {
                        Pet petA = Pet.fromSnapshot(snapshot.data);
                        return RaisedButton(
                          child: Text(petA.name),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => _PetA()));
                          }
                        );
                      }
                  }
                }
              )
            )
          ],
        ),
      )
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