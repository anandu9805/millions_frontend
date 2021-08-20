import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/provider.dart';
import 'package:millions/screens/explore.dart';
import 'package:millions/screens/googleSignIn.dart';
import 'package:millions/screens/myWallet.dart';
import 'package:millions/screens/notifications.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/screens/searchPage..dart';
import 'package:millions/screens/userMenu.dart';
import 'package:millions/services/userService.dart';
import 'package:provider/provider.dart';

class AppBarOthers extends StatefulWidget {
  @override
  _AppBarOthersState createState() => _AppBarOthersState();
}

class _AppBarOthersState extends State<AppBarOthers> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  String notificationCount = "0";

  Future<void> countUnreadNotifications() async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiver', isEqualTo: altUserId)
          .where('read', isEqualTo: false)
          .get()
          .then((doc) {
        if (doc.size > 10) {
          setState(() {
            notificationCount = "10+";
          });
        } else {
          setState(() {
            notificationCount = doc.size.toString();
          });
        }
      });
      print(notificationCount);
    } catch (e) {
      print("Error");
    }
  }

  Future<void> updateNotification() async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiver', isEqualTo: altUserId)
          .where('read', isEqualTo: false)
          .get()
          .then((querySnapshot) {
        var batch = FirebaseFirestore.instance.batch();
        querySnapshot.docs.forEach((document) {
          batch.update(document.reference, {'read': true});
        });

        return batch.commit();
      });
    } catch (e) {
      print("Error");
    }
  }

  int _lastIntegerSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countUnreadNotifications();
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
          child: Text("My Channel", style: GoogleFonts.ubuntu()),
          value: 'mychannel',
        ),
        PopupMenuItem(
          child: Text(
            "My Account",
            style: GoogleFonts.ubuntu(),
          ),
          value: 'editprofile',
        ),
        PopupMenuItem(
          child: Text("My Wallet", style: GoogleFonts.ubuntu()),
          value: 'mywallet',
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
          millionsprovider.logout(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GoogleSignIn()),
          );
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

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return AppBar(
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
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 5,
          ),
          child: IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: Colors.black87,
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
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            icon: Icon(
              Icons.explore,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Explore()),
              );
            },
          ),
        ),
        notificationCount != "0"
            ? Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                  top: 15,
                ),
                child: Stack(
                  children: <Widget>[
                    InkWell(
                      child: new Icon(
                        Icons.notifications,
                        color: Colors.black87,
                      ),
                      onTap: () {
                        updateNotification();
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationPage()),
                        );
                        countUnreadNotifications();
                      },
                    ),
                    new Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: new Text(
                          notificationCount,
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()),
                    );
                  },
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              // Navigator.of(context).push(new MaterialPageRoute<Null>(
              //     builder: (BuildContext context) {
              //       return UserMenu();
              //     },
              //     fullscreenDialog: true));
              _showPopupMenu(details.globalPosition);
            },
            child: CircleAvatar(
              foregroundImage: 
              NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
              radius: 15,
            ),
            // child: CircleAvatar(

            //   child: ClipRRect(
            //     child: Image.network(
            //       snapshot.data.toString(),
            //       //reels_objects[index].profilePic,
            //       width: w * 1,
            //       height: w * 1,
            //       fit: BoxFit.cover,
            //     ),
            //     borderRadius: BorderRadius.circular(w * 1),
            //   ),
            //   radius: 25,
            // ),
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
          ),
          // } else {
          //   return GestureDetector(
          //     onTapDown: (TapDownDetails details) {
          //       _showPopupMenu(details.globalPosition);
          //     },
          //     child: InkWell(
          //       child: CircleAvatar(
          //         //radius: w * 0.3,
          //         backgroundColor: Colors.black,
          //       ),
          //     ),
          //   );
          // }
          // }),
        ),
        // )
      ],
      backgroundColor: Colors.white,
    );
  }
}
