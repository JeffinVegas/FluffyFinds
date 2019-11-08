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

  Pet(this.battery, this.house, this.name, this.temperature);

  Pet.fromSnapshot(DataSnapshot snapshot)
      : battery = snapshot.value["battery"],
        house = snapshot.value["house"],
        name = snapshot.value['name'],
        temperature = snapshot.value["temperature"];

  toJson() {
    return {
      "battery": battery,
      "house": house,
      "name": name,
      "temperature": temperature,
    };
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> {
  var i;
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new FutureBuilder(
            future: FirebaseDatabase.instance.reference().child('petA').once(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    Pet pets = Pet.fromSnapshot(snapshot.data);
                    return new Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RaisedButton(
                            child: Text(pets.name),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => _PetA()),
                              );
                            },
                          ),
                          RaisedButton(
                            child: Text('Pet 2'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => _PetB()),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}
