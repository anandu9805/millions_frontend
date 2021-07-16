import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../model/reels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';

import 'package:google_fonts/google_fonts.dart';

class ChannelShorts extends StatefulWidget {
  final String channelId;
  ChannelShorts(this.channelId);

  @override
  _ShortsState createState() => _ShortsState();
}

class _ShortsState extends State<ChannelShorts> {
  //the id of the logged in user
  // var currentuserid = "DEyDJLaskaSXV5kMBLXSGBBZC062";
  List following_details = [];

  Future<void> deletenow(String coll, String doc) async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction
          .delete(FirebaseFirestore.instance.collection(coll).doc(doc));
    });
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: primary,
        ),
      ),
    );
  }

  @override
  void initState() {
    // getFollowingdetails();
    super.initState();
  }

  // Future<String> getFollowingdetails() async {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('followers')
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       querySnapshot.docs.forEach((doc) {
  //         print("in");
  //         if (doc['follower'] == altUserId)
  //           following_details.add(doc['channel']);
  //       });
  //       print("followerdetails:");
  //       print(following_details);
  //     });

  //   } catch (e) {
  //     return "Follow";
  //   }
  // }

  List<Reels> reels_objects = [];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reels')
            .where('channelId', isEqualTo: widget.channelId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Center(
                    child: CircularProgressIndicator(
                  color: primary,
                )));
          }
          if (snapshot.data.docs.isEmpty) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No 30s videos to show!",
                        style: GoogleFonts.ubuntu(fontSize: 15)),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(primary: primary),
                        child: Text("Go Back to Channel Page",
                            style: GoogleFonts.ubuntu(fontSize: 15)))
                  ],
                )));
          }
          if (snapshot.hasData) {
            reels_objects = snapshot.data.docs.map((doc) {
              Reels reelsItems = Reels.fromMap(doc.data());

              return reelsItems;
            }).toList();

            return Swiper(
              containerWidth: MediaQuery.of(context).size.width,
              itemBuilder: (BuildContext context, int index) {
                return Stack(children: [
                  ContentScreen(
                    src: reels_objects[index].videoSrc,
                  ),
                  Positioned(
                    left: w / 30,
                    bottom: h / 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            child: Image.network(
                              reels_objects[index].profilePic,
                              width: w * 1,
                              height: h * 1,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(w * 1),
                          ),
                          radius: 20,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              reels_objects[index].channelName,
                              style: GoogleFonts.ubuntu(color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            if (reels_objects[index].isVerified)
                              Icon(
                                Icons.verified,
                                size: 15,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        widget.channelId != altUserId
                            ? Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: primary),
                                    onPressed: () {
                                      if (!following_details.contains(
                                          reels_objects[index].channelId)) {
                                        setState(() {
                                          following_details.add(
                                              reels_objects[index].channelId);
                                        });
                                        FirebaseFirestore.instance
                                            .collection('followers')
                                            .doc(altUserId)
                                            .set({
                                          'channel':
                                              reels_objects[index].channelId,
                                          'date': DateTime.now(),
                                          'follower': altUserId
                                        });
                                      } else {
                                        print("already following");
                                      }
                                    },
                                    child: Text(
                                      !following_details.contains(
                                              reels_objects[index].channelId)
                                          ? 'Follow'
                                          : 'Following',
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          height: 1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              )
                            : Text(''),
                        Text(
                          reels_objects[index].description,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              height: 1,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: w / 80,
                    bottom: h / 7,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {}, //reels like function
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: () {}, //reels share function
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: () {
                            if (widget.channelId == altUserId) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Millions",
                                      style: GoogleFonts.ubuntu(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      //message,
                                      "Do You want to delete this 30s video?",
                                      style: GoogleFonts.ubuntu(),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "OK",
                                          style: GoogleFonts.ubuntu(
                                              color: primary),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deletenow("reels",
                                                  reels_objects[index].id)
                                              .whenComplete(() => _showToast(
                                                  context,
                                                  "30s Video deleted"));
                                        },
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Cancel",
                                          style: GoogleFonts.ubuntu(
                                              color: primary),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }, //reels report/delete function
                          icon: Icon(
                            widget.channelId == altUserId
                                ? Icons.delete
                                : Icons.flag_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              },
              // autoplay: true,
              //  itemWidth:DeviceSize(context).width*0.5,
              itemCount: reels_objects.length,
              scrollDirection: Axis.vertical,
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

/**/
