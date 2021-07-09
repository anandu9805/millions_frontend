import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/googleSignIn.dart';
import './screens/home.dart';

import 'package:provider/provider.dart';
import '../provider.dart';
import './screens/complete_profile.dart';

class Auth extends StatefulWidget {
  const Auth({Key key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var check = 1;
  //final currentuser = FirebaseAuth.instance.currentUser;

  // Future<int> User() async {
  //   // await  FirebaseFirestore.instance
  //   //       .collection('users').where('email',isEqualTo:currentuser.email )
  //   //       .get()
  //   //       .then((QuerySnapshot querySnapshot) {
  //   //     querySnapshot.docs.forEach((doc) {
  //   //       print(doc["place"]);
  //   //     });
  //   //   });
  //
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentuser.uid)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       print('Document exists on the database');
  //       return 1;
  //     } else {
  //       print("do not exist");
  //       return 0;
  //     }
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    final millionsprovider =
    Provider.of<MillionsProvider>(context, listen: false);


    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (snapshot.hasData) {

return HomePage();
//             print("inside outer stremreader"+snapshot.toString());
//             print( FirebaseAuth.instance.currentUser.email);
//               return StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection('users')
//                       .doc( FirebaseAuth.instance.currentUser.uid)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     print("inside inner stremreader"+snapshot.toString());
//
//                     if (snapshot.connectionState == ConnectionState.done)
//                       {
//                         if (snapshot.hasData) {
//                           print('Document exists on the database');
//                           return HomePage();
//                         } else {
//                           print("do not exist");
//                           return CreateProfile();
//                         }
//                       }
//
//
//                    else{
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   });


                  //  return check == 0 ? CreateProfile() : HomePage();
                  }
            else if (snapshot.hasError)
              return Center(
                child: Text('Somthing Went Wrong'),
              );
            else {
              // User(millionsprovider.googleAuth);
              return GoogleSignIn();
            }
          }),
    );
  }
}
