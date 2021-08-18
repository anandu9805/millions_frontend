import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:millions/provider.dart';
import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/createPost.dart';
import 'package:millions/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '';

class GoogleSignIn extends StatefulWidget {
  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.2),
            Container(
              height: 142,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/million logo with millions.png",
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Sign In',
                          style: GoogleFonts.ubuntu(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: FlatButton(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              final millionsprovider =
                                  Provider.of<MillionsProvider>(context,
                                      listen: false);
                              millionsprovider.googleLogin(context);
                            },
                            icon: Image.asset(
                              'images/google.png',
                              height: 22,
                            ),
                          ),
                          Text(
                            'Sign In With Google',
                            style: GoogleFonts.ubuntu(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        final millionsprovider = Provider.of<MillionsProvider>(
                            context,
                            listen: false);
                        User user = await millionsprovider.googleLogin(context);

                        print(user);
                        if (user != null) {
                          Future<SharedPreferences> prefs =
                              SharedPreferences.getInstance();
                          final SharedPreferences prefsData = await prefs;
                          prefsData.setInt('isFirstTime', 1);
                          isUserExist();
                        }
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
