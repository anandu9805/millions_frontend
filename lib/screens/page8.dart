import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/editChannel.dart';
import 'package:millions/screens/myShorts.dart';
import 'package:millions/widgets/appDrawer.dart';
import 'package:millions/widgets/channelReport.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:millions/widgets/photos.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String resultMessage, cname;
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
        if (doc.exists) {
          setState(() {
            followStatus = "Following";
          });
        } else {
          setState(() {
            followStatus = "Follow";
          });
        }
      });
      return followStatus;
    } catch (e) {
      print("Error");
      return '';
    }
  }

  void unfollow(String docID) async {
    try {
      await FirebaseFirestore.instance
          .doc("followers/$docID")
          .delete()
          .whenComplete(() {
        _showToast(context, "UnFollowed " + cname);
        FirebaseMessaging.instance.unsubscribeFromTopic(widget.channelId);
        setState(() {
          followStatus = "Follow";
        });
        // checkExist(widget.channelId);
      }).catchError(
              (error) => _showToast(context, "Failed to unfollow: $error"));
    } catch (e) {
      print("Error");
    }
  }

  void follow(String docID, Map details) async {
    try {
      await FirebaseFirestore.instance.doc("followers/$docID").set({
        'channel': details['channel'],
        'date': details['date'],
        'follower': details['follower']
      }).whenComplete(() {
        _showToast(context, "Following " + cname);
        FirebaseMessaging.instance.subscribeToTopic(widget.channelId);
        setState(() {
          followStatus = "Following";
        });
      }).catchError((error) => _showToast(context, "Failed to follow: $error"));
    } catch (e) {
      print("Error" + e.toString());
    }
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
      length: 4,
      child: Scaffold(
        key: _drawerKey,
        drawer: DefaultDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Video Search", style: GoogleFonts.ubuntu()),
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
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      color: Colors.white,
                      height: 160,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                            child: Text(
                          "Something went wrong",
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                  );
                }

                if (snapshot.hasData && !snapshot.data.exists) {
                  //if()
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      color: Colors.white,
                      height: 160,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Center(
                            child: Text(
                          "Channel does not exist !",
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        )),
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data.data() as Map<String, dynamic>;
                  ChannelModel channel = ChannelModel.fromDoc(data);
                  //() async=>{exists = await checkExist(userId + "_" + channel.id)};
                  cname = channel.channelName;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Colors.white,
                      height: 170,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Card(
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                (channel.channelArt == null ||
                                        channel.channelArt.isEmpty)
                                    ? altChannelArt
                                    : channel.channelArt,
                              ),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        (channel.profilePic == null ||
                                                channel.profilePic.isEmpty)
                                            ? altProfilePic
                                            : channel.profilePic,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 8, 0, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            channel.channelName.length > 15
                                                ? channel.channelName
                                                        .substring(0, 15) +
                                                    "...."
                                                : channel.channelName,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.ubuntu(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          if (channel.isVerified)
                                            Icon(
                                              Icons.verified_sharp,
                                              size: 20,
                                              color: Colors.blue,
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                        NumberFormat.compact()
                                                .format(channel.subsribers)
                                                .toString() +
                                            ' Subscribers',
                                        style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 8, 0, 0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: primary,
                                          ),
                                          onPressed: () {
                                            if (channel.id == altUserId)
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditChannel(channel)),
                                              );
                                            else {
                                              setState(() {
                                                if (followStatus == "Following")
                                                  unfollow(altUserId +
                                                      "_" +
                                                      channel.id);
                                                else {
                                                  Map details = {
                                                    'channel': channel.id,
                                                    'date': FieldValue
                                                        .serverTimestamp(),
                                                    'follower': altUserId
                                                  };
                                                  follow(
                                                      altUserId +
                                                          "_" +
                                                          channel.id,
                                                      details);
                                                }
                                              });
                                            }
                                          },
                                          child: Text(
                                            channel.id == altUserId
                                                ? "Edit Channel"
                                                : followStatus,
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
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
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Container(
                    color: Colors.white,
                    height: 160,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Container(
                        height: 170.0,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: Center(
                            child: Text(
                          "Loading Channel Details...",
                          style: GoogleFonts.ubuntu(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                      ),
                    ),
                  ),
                );
              },
            ),

            // the tab bar with two items
            Divider(
              color: primary,
              thickness: 1.5,
            ),
            SizedBox(
              height: 50,
              child: AppBar(
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: primary,
                  indicatorWeight: 2,
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
                    Tab(
                      child: Text('About',
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
                                fromwhere: 0,
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
                              // height: MediaQuery.of(context).size.height * 0.25,
                              child: Column(children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "https://millionsofficial.github.io/static/search.jpg",
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: primary, elevation: 0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChannelShorts(
                                              widget.channelId,
                                            )),
                                  );
                                },
                                child: Text(
                                  "View all 30s of this channel",
                                  style: GoogleFonts.ubuntu(fontSize: 15),
                                ),
                              ),
                            )
                          ]));
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
                    child: FutureBuilder<DocumentSnapshot>(
                      future: channelDetails,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        // if(snapshot.data.exists==false){
                        //   return Container(
                        //       height: MediaQuery.of(context).size.height * 0.25,
                        //       child: Center(
                        //           child: Text("Nothing to show",
                        //               style:
                        //               GoogleFonts.ubuntu(fontSize: 15))));
                        // }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: primary,
                              )));
                        }
                        if (snapshot.hasData && snapshot.data.exists) {
                          ChannelModel channelmodel =
                              ChannelModel.fromDoc(snapshot.data.data());
                          return Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('About Channel',
                                      style: GoogleFonts.ubuntu(fontSize: 18)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Text(
                                      "Channel Description : " +
                                          (snapshot.data['description'] == ""
                                              ? "No Description Provided"
                                              : snapshot.data['description']),
                                      maxLines: 5,
                                      style: GoogleFonts.ubuntu(fontSize: 13)),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  // SizedBox(height: MediaQuery.of(context).size.height*0.05),
                                  Text('Links',
                                      style: GoogleFonts.ubuntu(fontSize: 18)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  if (snapshot.data['linkone'] != '')
                                    InkWell(
                                        onTap: () {
                                          launch(
                                              snapshot.data['linkone']);
                                        },
                                        child: Text(snapshot.data['linkone'],
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.blue,
                                                fontSize: 13))),
                                  if (snapshot.data['linktwo'] != '')
                                    InkWell(
                                        onTap: () {
                                          launch(
                                              snapshot.data['linktwo']);
                                        },
                                        child: Text(snapshot.data['linktwo'],
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.blue,
                                                fontSize: 13))),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  Text('Details',
                                      style: GoogleFonts.ubuntu(fontSize: 18)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Text(
                                      "Country Code : " +
                                          snapshot.data['country'],
                                      style: GoogleFonts.ubuntu(fontSize: 13)),
                                  Text(
                                      "Created On : " +
                                          channelmodel.created
                                              .toDate()
                                              .toString(),
                                      style: GoogleFonts.ubuntu(fontSize: 13)),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: primary),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReportChannel(
                                            channel: channelmodel,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Report Channel",
                                      style: GoogleFonts.ubuntu(fontSize: 15),
                                    ),
                                  ),
                                ]),
                          );
                        } else {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: Text("Nothing to show",
                                      style:
                                          GoogleFonts.ubuntu(fontSize: 15))));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
