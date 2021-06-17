import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Banner(
            message: "20% off !!",
            location: BannerLocation.bottomStart,
            color: Colors.red,
            child: Container(
              color: Colors.green[100],
              height: 300,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: <Widget>[
                    Image.network(
                        'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20190806131525/forkPython.jpg'), //Image.network
                    SizedBox(height: 10),
                    Text(
                      'GeeksforGeeks',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 40,
                          fontWeight: FontWeight.bold), //TextStyle
                    ),
                    SizedBox(
                      height: 5,
                    ), //SizedBox
                    Text(
                      'Fork Python Course',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold), //TextStyle
                    ), //Text
                    SizedBox(height: 20),
                    RaisedButton(
                      child: Text('Register'),
                      color: Colors.greenAccent[400],
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
