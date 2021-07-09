import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/widgets/appbar_others.dart';

import '../widgets/photos.dart';

class Screen11 extends StatefulWidget {
  @override
  _Screen11State createState() => _Screen11State();
}

class _Screen11State extends State<Screen11> {
  @override
  Widget build(BuildContext context) {

    var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;
    return Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 5),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Posts',
                      style:
                          GoogleFonts.ubuntu(fontSize: 25, color: Colors.black54),
                    )),
              ),
            ),
            Container(
              height: (h) - ((h) * (1 / 8)) - ((h) * (1 / 8.5)),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Photos(index);
                },
                scrollDirection: Axis.vertical,
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
