import 'package:flutter/material.dart';
import 'package:millions/screens/complete_profile.dart';

import '../widgets/photos.dart';

class Screen11 extends StatefulWidget {
  @override
  _Screen11State createState() => _Screen11State();
}

class _Screen11State extends State<Screen11> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                  height: 142,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/million final logo with out millions.png",
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            ListTile(
              title: Text('Create Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProfile()),
                );
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (h) * (1 / 13),
        ),
        child: AppBar(
          leading: Container(
            color: Colors.white,
            width: w / 4,
            child: IconButton(
              icon: Image.asset(
                'images/million final logo with out millions.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.centerRight,
              ),
              onPressed: () {
                openDrawer();
              },
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
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Photos',
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
