import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/screens/login.dart';
import '../constants/colors.dart';
import '../auth.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    //var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primary, //Color(0xffa31545),
      body: Container(
        child: Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 20),
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: h / 8,
                        width: h / 4,
                        child: Image.asset(
                          'images/white millions logo with millions.png',
                          height: 40,
                          width: 40,
                        ))
                  ],
                ),
                SizedBox(
                  height: h / 15,
                ),
                Container(
                  //width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    'Watch,\nStream,\nEarn,\nAnywhere,\nAnytime ',
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50,
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Auth()),
                        );
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
    );
  }
}
