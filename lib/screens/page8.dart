import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/editChannel.dart';
import 'package:millions/screens/myShorts.dart';
import 'package:millions/widgets/appDrawer.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:millions/widgets/photos.dart';

class Page8 extends StatefulWidget {
  final String channelId;
  Page8(this.channelId);
  @override
  _Page8State createState() => _Page8State();
}

class _Page8State extends State<Page8> {
  Stream<QuerySnapshot<Map<String, dynamic>>> videoStream;
  Stream<QuerySnapshot<Map<String, dynamic>>> postStream;
  String followStatus = "Follow";
  String resultMessage;
  Future<DocumentSnapshot<Map<String, dynamic>>> channelDetails, followDetails;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  Future<String> checkExist(String docID) async {
    try {
      await FirebaseFirestore.instance
          .doc("followers/$docID")
          .get()
          .then((doc) {
        if (doc.exists)
          followStatus = "Unfollow";
        else
          followStatus = "Follow";
      });
      return followStatus;
    } catch (e) {
      return "Follow";
    }
  }

  Future<void> unfollow(String docID) {
    return FirebaseFirestore.instance
        .doc("followers/$docID")
        .delete()
        .then((value) => setState(() {
              resultMessage = "Unfollowed ";
            }))
        .catchError((error) => setState(() {
              resultMessage = "Failed to unfollow ";
            }));
  }

  Future<void> follow(String docID, Map details) {
    return FirebaseFirestore.instance
        .doc("followers/$docID")
        .set({
          'channel' : details['channel'],
          'date' : details['date'],
          'follower' : details['follower']
        })
        .then((value) => setState(() {
              resultMessage = "Following ";
            }))
        .catchError((error) => setState(() {
              resultMessage = "Failed to Follow ";
            }));
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
  initState() {
    super.initState();
    checkExist(altUserId + "_" + widget.channelId)
        .then((value) => followStatus = value);
    videoStream = FirebaseFirestore.instance
        .collection("videos")
        .where('channelId', isEqualTo: widget.channelId)
        .where("isVisible", isEqualTo: "Public")
        .orderBy("date", descending: true)
        .snapshots();
    postStream = FirebaseFirestore.instance
        .collection("posts")
        .where("isVisible", isEqualTo: "Public")
        .where("channelId", isEqualTo: widget.channelId)
        .orderBy("date", descending: true)
        .snapshots();
    channelDetails = FirebaseFirestore.instance
        .collection("channels")
        .doc(widget.channelId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _drawerKey,
        drawer: DefaultDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            // construct the profile details widget here
            FutureBuilder<DocumentSnapshot>(
              future: channelDetails,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    "Something went wrong",
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                if (snapshot.hasData && !snapshot.data.exists) {
                  //if()
                  return Center(
                    child: Text(
                      "Channel does not exist",
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data.data() as Map<String, dynamic>;
                  ChannelModel channel = ChannelModel.fromDoc(data);
                  //() async=>{exists = await checkExist(userId + "_" + channel.id)};
                  return Container(
                    width: double.infinity,
                    height: 165,
                    color: Colors.white,
                    //decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                (channel.channelArt == null ||
                                        channel.channelArt.isEmpty)
                                    ? altChannelArt
                                    : channel.channelArt,
                              ),
                              //  'https://motionarray.imgix.net/preview-75634-8YcoQ8Fyf3_0000.jpg'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  child: ClipRRect(
                                    child: Image.network(
                                      (channel.profilePic == null ||
                                              channel.profilePic.isEmpty)
                                          ? altProfilePic
                                          : channel.profilePic,
                                      //data['profilePic'],
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width * 1),
                                  ),
                                  // backgroundColor: Colors.black,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 50, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            //username,
                                            channel.channelName,
                                            style: GoogleFonts.ubuntu(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 4, 0, 0),
                                            child: Text(
                                              channel.subsribers.toString() +
                                                  ' Subscribers',
                                              style: GoogleFonts.ubuntu(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (channel.id == altUserId)
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditChannel(
                                                                channel)),
                                                  );
                                                else {
                                                  setState(() {
                                                    if (followStatus ==
                                                        "Unfollow")
                                                      unfollow(altUserId +
                                                              "_" +
                                                              channel.id)
                                                          .whenComplete(() =>
                                                              _showToast(
                                                                  context,
                                                                  resultMessage +
                                                                      channel
                                                                          .channelName));
                                                    else {
                                                      Map details = {
                                                        'channel':
                                                            channel.id,
                                                        'date': FieldValue
                                                            .serverTimestamp(),
                                                        'follower': altUserId
                                                      };
                                                      follow(
                                                              altUserId +
                                                                  "_" +
                                                                  channel.id,
                                                              details)
                                                          .whenComplete(() =>
                                                              _showToast(
                                                                  context,
                                                                  resultMessage +
                                                                      channel
                                                                          .channelName));
                                                    }
                                                    checkExist(channel.channelName);
                                                  });
                                                }
                                              },
                                              child: Text(
                                                channel.id == altUserId
                                                    ? "Edit Channel"
                                                    : followStatus,
                                                style: GoogleFonts.ubuntu(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Center(
                  child: Text(
                    "Loading Channel Details..",
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),

            // the tab bar with two items
            SizedBox(
              height: 50,
              child: AppBar(
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: primary,
                  tabs: [
                    Tab(
                      child: Text('Videos',
                          style: GoogleFonts.ubuntu(color: Colors.black)),
                    ),
                    Tab(
                      child: Text('Posts',
                          style: GoogleFonts.ubuntu(color: Colors.black)),
                    ),
                    Tab(
                      child: Text('30s',
                          style: GoogleFonts.ubuntu(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  SingleChildScrollView(
                    child: StreamBuilder(
                      stream: videoStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: primary,
                              )));
                        }
                        if (snapshot.data.docs.isEmpty) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: Text("No videos to show!",
                                      style:
                                          GoogleFonts.ubuntu(fontSize: 15))));
                        }
                        if (snapshot.hasData) {
                          return new ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: snapshot.data.docs.map((doc) {
                              Video videoItems = Video.fromMap(doc.data());
                              return VideoCard(
                                video: videoItems,
                              );
                            }).toList(),
                          );
                        } else {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: Text("Unknown Error Occured!",
                                      style:
                                          GoogleFonts.ubuntu(fontSize: 15))));
                        }
                      },
                    ),
                  ),

                  // second tab bar viiew widget
                  SingleChildScrollView(
                    child: StreamBuilder(
                      stream: postStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: primary,
                              )));
                        }
                        if (snapshot.data.docs.isEmpty) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: Text("No posts to show!",
                                      style:
                                          GoogleFonts.ubuntu(fontSize: 15))));
                        }
                        if (snapshot.hasData) {
                          return new ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: snapshot.data.docs.map((doc) {
                              PostDetail photoItems =
                                  PostDetail.fromMap(doc.data());
                              return Container(
                                child: Photos(photoItems),
                              );
                            }).toList(),
                          );
                        } else {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: Text("Unknown Error Occured!",
                                      style:
                                          GoogleFonts.ubuntu(fontSize: 15))));
                        }
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('reels')
                          .where('channelId', isEqualTo: widget.channelId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: primary,
                              )));
                        }
                        if (snapshot.data.docs.isEmpty) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: Text("No 30s videos to show!",
                                      style:
                                          GoogleFonts.ubuntu(fontSize: 15))));
                        }
                        if (snapshot.hasData) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primary),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChannelShorts(widget.channelId)),
                                    );
                                  },
                                  child: Text(
                                    "View all 30s of this channel",
                                    style: GoogleFonts.ubuntu(fontSize: 15),
                                  ),
                                ),
                              ));
                        } else {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: Text("Unknown Error Occured!",
                                      style:
                                          GoogleFonts.ubuntu(fontSize: 15))));
                        }
                      },
                    ),
                  ),

                  // SingleChildScrollView(
                  //   child: StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('reels')
                  //         .where('channelId', isEqualTo: altUserId)
                  //         .snapshots(),
                  //     builder: (BuildContext context,
                  //         AsyncSnapshot<QuerySnapshot> snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return Container(
                  //             height: MediaQuery.of(context).size.height * 0.25,
                  //             child: Center(
                  //                 child: CircularProgressIndicator(
                  //               color: primary,
                  //             )));
                  //       }
                  //       if (snapshot.data.docs.isEmpty) {
                  //         return Container(
                  //             height: MediaQuery.of(context).size.height * 0.25,
                  //             child: Center(
                  //                 child: Text("No 30s to show!",
                  //                     style:
                  //                         GoogleFonts.ubuntu(fontSize: 15))));
                  //       }
                  //       if (snapshot.hasData) {
                  //         return new ListView(
                  //           physics: NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           children: snapshot.data.docs.map((doc) {
                  //             Reels reelsItems = Reels.fromMap(doc.data());
                  //             return InkWell(
                  //               onTap: () {
                  //                 Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => ContentScreen(
                  //                           src: reelsItems.videoSrc)),
                  //                 );
                  //               },
                  //               child: Image.network(
                  //                   reelsItems.generatedThumbnail),
                  //             );
                  //           }).toList(),
                  //         );
                  //       } else {
                  //         return Container(
                  //             height: MediaQuery.of(context).size.height * 0.25,
                  //             child: Center(
                  //                 child: Text("Unknown Error Occured!",
                  //                     style:
                  //                         GoogleFonts.ubuntu(fontSize: 15))));
                  //       }
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
