import 'package:flutter/material.dart';
import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/user_profile.dart';
import 'package:millions/screens/view_video.dart';
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
      home: UserProfile(),
    );
  }
}
