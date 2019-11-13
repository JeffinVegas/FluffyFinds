import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
part 'petA.dart';
part 'petB.dart';

class Pet {
  int battery;
  String house;
  String name;
  int temperature;
  double latitudes;
  double longtitudes;
  String picture;

  Pet(this.battery, this.house, this.name, this.temperature, this.latitudes, this.longtitudes, this.picture);

  Pet.fromSnapshot(DataSnapshot snapshot):
    battery = snapshot.value["battery"],
    house = snapshot.value["house"],
    name = snapshot.value['name'],
    temperature = snapshot.value["temperature"],
    latitudes = snapshot.value["latitude"],
    longtitudes = snapshot.value["longtitude"],
    picture = snapshot.value['picture'];
  toJson() {
    return {
      "battery": battery,
      "house": house,
      "name": name,
      "temperature": temperature,
      "latitude": latitudes,
      "longtitude": longtitudes,
      "picture": picture,
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
  //File _image;
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    // Future getImage() async {
    //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //   setState(() {
    //     _image = image;
    //     print('Image Path $_image');
    //   });
    // }
    String url;
    Future getimage() async {
      final refs = FirebaseStorage.instance.ref().child('dog2.jpeg');
        url = await refs.getDownloadURL();
      print(url);
      
    }
    void updateImage(String url){
      ref.child("petB").update({'picture': url});
    }
    getimage();
    // updateImage(url);
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
                        return Column(
                          children: <Widget>[
                            RaisedButton(
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: CachedNetworkImageProvider(petA.picture),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => _PetA()));
                              }
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: ShapeDecoration(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.redAccent))
                              ),
                              child: Text(
                                petA.name,
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }
                  }
                }
              ),
            ),
            Divider(color: Colors.transparent,),
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
                        Pet petB = Pet.fromSnapshot(snapshot.data);
                        return Column(
                          children: <Widget>[
                            RaisedButton(
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: CachedNetworkImageProvider(petB.picture),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => _PetA()));
                              }
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: ShapeDecoration(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.redAccent))
                              ),
                              child: Text(
                                petB.name,
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
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
