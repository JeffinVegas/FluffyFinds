import 'package:flutter/material.dart';
import 'screens/front.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FluffyFinds',
      theme: ThemeData(

        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('FluffyFinds'), centerTitle: true),
        body: Home(),
      ),
    );
  }
}