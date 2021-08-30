import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/googleSignIn.dart';
import 'package:millions/screens/home.dart';
import 'package:millions/screens/login.dart';
import 'package:millions/screens/screen1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  int isFirstTime;
  Future<void> _isFirstTime() async {
    final SharedPreferences prefsData = await prefs;
    setState(() {
      isFirstTime = prefsData.getInt('isFirstTime') ?? 0;
    });
    print(isFirstTime == 0 ? "first time" : "not first time");
  }

  @override
  void initState() {
    _isFirstTime();
    super.initState();
    _mockCheckForSession().then((status) {
      if (status) {
        isUserExist();
      } else {
        print(isFirstTime);
        isFirstTime == 0 ? _navigateToFirstScreen() : _navigateToLogin();
      }
    });
  }

  Future isUserExist() async {
    Future<QuerySnapshot<Map<String, dynamic>>> result = FirebaseFirestore
        .instance
        .collection('users')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    result.then((value) {
      print(value.docs.length);
      if (value.docs.length > 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfile(
              uid: FirebaseAuth.instance.currentUser.uid,
            ),
          ),
        );
      }
    }).whenComplete(() => null);
  }

  Future<bool> _mockCheckForSession() async =>
      await Future.delayed(Duration(milliseconds: 2000), () {
        return FirebaseAuth.instance.currentUser != null ? true : false;
      });

  void _navigateToFirstScreen() async {
    final SharedPreferences prefsData = await prefs;
    prefsData.setInt('isDarkMode', 0);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Screen1()));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => GoogleSignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Image.asset(
          'images/white millions logo with millions.png',
          width: MediaQuery.of(context).size.width * 0.25,
        ),
      ),
    );
  }
}
