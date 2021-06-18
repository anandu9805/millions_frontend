import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: (h) * 1 / 14,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  height: (h) * 1 / 14,
                  width: double.infinity,
                  child: Text(
                    'Add banner comes here',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Photos',
                    style: TextStyle(fontSize: 25, color: Colors.black54),
                  )),
            ),
          ),
          Container(
            height: (h) - ((h) * (1 / 8)) - ((h) * (1 / 8.5)),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Photos();
              },
              scrollDirection: Axis.vertical,
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
