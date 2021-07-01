import 'package:flutter/material.dart';
import 'package:millions/model/story.dart';
import 'package:millions/screens/home.dart';
import 'package:millions/screens/screen1.dart';
import 'package:millions/screens/story.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
       home: Screen1(),
     // home: HomePage(),
    );
  }
}
