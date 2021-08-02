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

  void _showPopupMenu(Offset offset) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy,
          MediaQuery.of(context).size.width - offset.dx,
          MediaQuery.of(context).size.height - offset.dy),
      items: [
        PopupMenuItem(
          child: Text(
            "Edit Profile",
            style: GoogleFonts.ubuntu(),
          ),
          value: 'editprofile',
        ),
        PopupMenuItem(
          child: Text("My Wallet", style: GoogleFonts.ubuntu()),
          value: 'mywallet',
        ),
        PopupMenuItem(
          child: Text("My Channel", style: GoogleFonts.ubuntu()),
          value: 'mychannel',
        ),
        PopupMenuItem(
          child: Text("Logout", style: GoogleFonts.ubuntu()),
          value: 'logout',
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        if (value == 'logout') {
          final millionsprovider =
              Provider.of<MillionsProvider>(context, listen: false);
          millionsprovider.logout();
        } else if (value == 'mywallet') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyWallet()),
          );
        } else if (value == 'mychannel') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Page8(altUserId)),
          );
        } else if (value == 'editprofile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Screen14()),
          );
        }
      }

// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null
    });
  }

  final pages = [Screen5(0), Shorts(), CreatePage(), Screen9(), Screen11("")];
  int page = 0;
    var userDetalis;
  Future<String> userProfilePic;
  @override
  initState() {
    userProfilePic = UserServices().getUserDetails(altUserId);
    super.initState();
    
    print(FirebaseAuth.instance.currentUser);
    print(FirebaseAuth.instance.currentUser.displayName+"132");
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

                padding: const EdgeInsets.only(top: 10,),
                child: IconButton(
                  icon: Icon(
                    Icons.search_outlined,
                    color:primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
              ),
              Padding(

                padding: const EdgeInsets.only(top: 10,right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.explore,
                    color:primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Explore()),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: FutureBuilder(
                    future: UserServices().getUserDetails(altUserId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            _showPopupMenu(details.globalPosition);
                          },
                          child:     CircleAvatar(
                            child: ClipRRect(
                              child: Image.network(
                                snapshot.data.toString(),
                                //reels_objects[index].profilePic,
                                width: w * 1,
                                height: h * 1,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(w * 1),
                            ),
                            radius: 25,
                          ),
                          /*CircleAvatar(radius: 20,
                            child: ClipRRect(
                              child: Image.network(
                                snapshot.data.toString(),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(w * 0.1),
                            ),
                            //backgroundColor: Colors.black,
                          ),*/
                        );
                      } else {
                        return GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            _showPopupMenu(details.globalPosition);
                          },
                          child: InkWell(
                            child: CircleAvatar(
                              radius: w * 0.1,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        );
                      }
                    }),
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
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create"),
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
