import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/photos.dart';

class Screen5 extends StatefulWidget {
  @override
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  @override
  Widget build(BuildContext context) {
    // var ifphotos = true;
    var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                /*  Container(
                  height: (h) * 1 / 14,
                  width: double.infinity,
                  child: Text(
                    'Add banner comes here',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                ),*/
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hello Anandu',
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black54),
                      )),
                )
              ],
            ),
            color: Colors.white,
            width: double.infinity,
            height: (h) * 1 / 20,
          ),
          Container(
            color: Colors.white,
            height: (h) - ((h) * (1 / 8)) - ((h) * (1 / 10.16)),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Photos(index);
              },
              scrollDirection: Axis.vertical,
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
