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
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
            width: (w),
            height: h * 0.13,
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
                          radius: w * 0.1,
                          child: ClipRRect(
                            child: Image.asset(
                              'images/millionlogo.png',
                              width: w * 0.16,
                              height: w * 0.16,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(w * 0.1),
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
          padding: const EdgeInsets.only(top: 9, left: 5),
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
                child: Photos(),
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
