import 'package:flutter/material.dart';
import 'package:millions/screens/otpPage.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    timer().then((status) {
      if (status) {
        //   _navigateToHome();
        // } else {
        _navigateToLogin();
      }
    });
  }

  Future<bool> timer() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});

    return true;
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => OTPPageWidget()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffa31545),
      body: Container(
        child: Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 20),
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Image.asset('images/whiteicon.png'),
                SizedBox(
                  height: 150,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    'Watch Stream Earn Anywhere Anytime ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 60,
                    ),
                    maxLines: 5,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                    FlatButton(
                        onPressed: null,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 50,
                        ))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
