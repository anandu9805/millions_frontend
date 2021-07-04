import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/googleSignIn.dart';
import './screens/home.dart';

import 'package:provider/provider.dart';
import '../provider.dart';


class Auth extends StatefulWidget {
  const Auth({Key key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final currentuser=FirebaseAuth.instance.currentUser;

  User(var authResult) async{
    // await FirebaseFirestore.instance
    //     .collection('users').where('email',isEqualTo:currentuser.email ).get().then((value){
    //       print("User exists");
    //       print(value);
    // });

    FirebaseFirestore.instance
        .collection('users').where('email',isEqualTo:currentuser.email )
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["place"]);
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    final millionsprovider = Provider.of<MillionsProvider>(
        context,
        listen: false);


    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (snapshot.hasData)
              {
                User(millionsprovider.googleAuth);
                return HomePage();

              }

            else if (snapshot.hasError)
              return Center(
                child: Text('Somthing Went Wrong'),
              );
            else{
             // User(millionsprovider.googleAuth);
              return GoogleSignIn();}
          }),
    );
  }
}
