import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/photos.dart';

class Screen9 extends StatefulWidget {
  @override
  _Screen9State createState() => _Screen9State();
}

class _Screen9State extends State<Screen9> {
  @override
  Widget build(BuildContext context) {
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
      body: Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
            width: (w),
            height: (h)/8,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Row(children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          child: ClipRRect(
                            child: Image.asset(
                              'images/millionlogo.png',
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text('data')
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  )
                ]);
              },
              scrollDirection: Axis.horizontal,
              itemCount: 50,
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(top:9, left: 5),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Follow',
                style: TextStyle(fontSize: 25, color: Colors.black54),
              )),
        ),
        Container(
          height: (h) - (h * 1 / 11) - (h * 1 / 13) - 90.30,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                child:Photos(),
              );
            },
            scrollDirection: Axis.vertical,
            itemCount: 50,
          ),
        )
      ]),
    );
  }
}
