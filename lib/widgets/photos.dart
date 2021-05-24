import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Photos extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Image.asset('images/millionlogo.png')),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.only(top: 8),
              title: Text(
                'Former child actress who ended up being super rich',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 6, left: 20, right: 20),
                child: Text(
                  "User name",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6, left: 20, right: 20),
                child: Text(
                  "upload time",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
