import 'package:flutter/material.dart';

import './screens/screen11.dart';
import './screens/screen5.dart';
import './screens/screen1.dart';
import './screens/screen9.dart';
import './screens/screen14.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
     // home: Screen11(),
      home: Screen14(),

    );
  }
}

