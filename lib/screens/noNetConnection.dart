import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/million logo no internet.png",
            ),
            Text("No Internet Connection Found!\nPlease Check Your Connection",
                style: GoogleFonts.ubuntu(fontSize: 20)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: primary,
            //         borderRadius: BorderRadius.all(Radius.circular(15))),
            //     width: MediaQuery.of(context).size.width * 0.25,
            //     //color: primary,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Center(
            //         child: Text(
            //           'Try Again',
            //           style:
            //               GoogleFonts.ubuntu(color: Colors.white, fontSize: 15),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
