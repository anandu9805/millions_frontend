import 'package:flutter/material.dart';

import '../widgets/photos.dart';

class Screen5 extends StatefulWidget {
  @override
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {


  @override
  Widget build(BuildContext context) {
    var ifphotos=true;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (h) * (1 / 13),
        ),
        child: AppBar(
          leading: Container(
            color: Colors.white,
            width: w / 4,
            child: Image.asset(
              'images/million final logo with out millions.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.centerRight,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: IconButton(
                  icon: Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //go to search screen
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: CircleAvatar(
                backgroundColor: Colors.black,
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
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
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Hello Anandu',
                        style: TextStyle(fontSize: 25, color: Colors.black54),
                      )),
                )
              ],
            ),
            color: Colors.white,
            width: double.infinity,
            height: (h) * 1 / 8.5,
          ),
          Container(
            color: Colors.white,
            height: (h) - ((h) * (1 / 8)) - ((h) * (1 / 10.16)),
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
