//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
//import 'package:millions/screens/complete_profile.dart';
import 'package:algolia/algolia.dart';
import 'package:millions/screens/createPost.dart';
import 'package:millions/screens/follow_page.dart';
import 'package:millions/screens/page8.dart';
//import 'package:millions/screens/page8.dart';
import 'package:millions/screens/screen11.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/screens/screen5.dart';
import 'package:millions/screens/searchPage..dart';
import 'package:millions/screens/shorts.dart';
import 'package:millions/services/userService.dart';
import 'package:millions/widgets/appDrawer.dart';
import 'package:millions/widgets/appbar_others.dart';
//import 'package:millions/screens/screen9.dart';
import 'package:provider/provider.dart';
import '../provider.dart';
import 'myWallet.dart';
import '../screens/explore.dart';

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


  final pages = [Screen5(0), Shorts(), CreatePage(), Screen9(), Screen11(null)];
  int page = 0;
  var userDetalis;
  Future<String> userProfilePic;
  @override
  initState() {
    // userProfilePic = UserServices().getUserDetails(altUserId);
    super.initState();

    //print(FirebaseAuth.instance.currentUser);
    //print(FirebaseAuth.instance.currentUser.displayName + "132");
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
        
        body: pages[page],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: page,selectedLabelStyle: GoogleFonts.ubuntu(),
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
                icon: Icon(Icons.music_video), label: "30s"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create"),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library), label: "Follow"),
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
