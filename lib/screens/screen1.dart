import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/login.dart';
import '../constants/colors.dart';
import '../auth.dart';
import 'home.dart';
import 'googleSignIn.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  void initState() {
    // if (FirebaseAuth.instance.currentUser.uid != null) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePage()),
    //   );
    // }
    super.initState();
  }

  var _isLogin = false;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    //var w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary, //Color(0xffa31545),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: h * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Image.asset(
                                  'images/white millions logo with millions.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                //width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  'Watch,\nStream,\nEarn,\nAnywhere\nAnytime ',
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: h * 0.06,
                                  ),
                                  maxLines: 5,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                      TextButton(
                        onPressed: () {
                          // if (FirebaseAuth.instance.currentUser != null) {
                          //   print("user loggedin");
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => CreateProfile(
                          //         uid: FirebaseAuth.instance.currentUser.uid ??
                          //             '',
                          //       ),
                          //     ),
                          //   );
                          // } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          // }
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 50,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
