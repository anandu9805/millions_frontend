//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
//import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/createPost.dart';
import 'package:millions/screens/follow_page.dart';
//import 'package:millions/screens/page8.dart';
import 'package:millions/screens/screen11.dart';
import 'package:millions/screens/screen5.dart';
import 'package:millions/screens/shorts.dart';
import 'package:millions/services/userService.dart';
import 'package:millions/widgets/appDrawer.dart';
//import 'package:millions/screens/screen9.dart';
import 'package:provider/provider.dart';
import '../provider.dart';

// import 'package:millions/screens/uploadpage.dart';
//import 'package:millions/screens/user_profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  final pages = [Screen5(), Shorts(), CreatePage(), Screen9(), Screen11()];
  int page = 0;
  var userDetalis;
  Future<String> userProfilePic;
  @override
  initState() {
    userProfilePic = UserServices().getUserDetails(altUserId);
    print(userProfilePic.toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _drawerKey,
        drawer: DefaultDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            (h) * (1 / 13),
          ),
          child: AppBar(
            leading: Container(
              color: Colors.white,
              width: w / 4,
              child: InkWell(
                child: Image.asset(
                  'images/million final logo with out millions.png',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.centerRight,
                ),
                onTap: () {
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
                child: InkWell(
                  child: FutureBuilder(
                      future: UserServices().getUserDetails(altUserId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CircleAvatar(
                            child: ClipRRect(
                              child: Image.network(
                                snapshot.data.toString(),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(w * 0.1),
                            ),
                            //backgroundColor: Colors.black,
                          );
                        } else {
                          return CircleAvatar(
                            radius: w * 0.1,
                            backgroundColor: Colors.black,
                          );
                        }
                      }),
                  onTap: () {
                    final millionsprovider =
                        Provider.of<MillionsProvider>(context, listen: false);
                    millionsprovider.logout();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Page8()),
                    // );
                  },
                ),
              )
            ],
            backgroundColor: Colors.white,
          ),
        ),
        body: pages[page],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: page,
          showUnselectedLabels: false,
          backgroundColor: primary,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          elevation: 0,
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.white),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_label), label: "30s"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Post video"),
            BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions), label: "Follow"),
            BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Photos"),
          ],
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
        ),
      ),
    );
  }
}
