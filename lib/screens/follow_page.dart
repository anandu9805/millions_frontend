import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/user.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/followersShorts.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:millions/widgets/photos.dart';
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:millions/screens/page8.dart';

class Screen9 extends StatefulWidget {
  @override
  _Screen9State createState() => _Screen9State();
}

class _Screen9State extends State<Screen9> {
  UserDetail user;
  List followersId = [];
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    List d = [];
    Map<String, dynamic> channeldata;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('followers')
              .where('follower', isEqualTo: altUserId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              d = snapshot.data.docs.map((doc) {
                return doc.data() as Map<String, dynamic>;
              }).toList();
              var temp = d.length - 1;
              followersId = [];
              while (temp >= 0) {
                followersId.add(d[temp]['channel']);
                temp = temp - 1;
              }
              //print(followersId);
              if (followersId.isEmpty)
                return Center(
                    child: Text(
                  "You are not following any channels!",
                  style: GoogleFonts.ubuntu(fontSize: 20),
                ));
              CollectionReference channels =
                  FirebaseFirestore.instance.collection('channels');
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: h * 0.16,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: channels.doc(d[index]['channel']).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.connectionState ==
                                    // ""
                                    ConnectionState.done) {
                                  //   flag=1;
                                  channeldata = snapshot.data.data()
                                      as Map<String, dynamic>;

                                  return Row(children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Page8(
                                                        d[index]['channel'])),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: w * 0.1,
                                              child: ClipRRect(
                                                child: Image.network(
                                                  channeldata['profilePic'] ==
                                                          ""
                                                      ? altProfilePic
                                                      : channeldata[
                                                          'profilePic'],
                                                  width: w * 0.16,
                                                  height: w * 0.16,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.1),
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: w * 0.2,
                                            alignment: Alignment.center,
                                            padding:
                                                EdgeInsets.only(right: 1.0),
                                            child: Text(
                                                channeldata['channelName'],
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 12)))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ]);
                                }

                                return Center(
                                  child: CircleAvatar(
                                    radius: w * 0.1,
                                    child: ClipRRect(
                                      child: Image.network(
                                        altProfilePic,
                                        width: w * 0.16,
                                        height: w * 0.16,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.1),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: d.length,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 8, bottom: 12),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Following',
                          style: GoogleFonts.ubuntu(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        )),
                  ),
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
                  Expanded(
                    child: TabBarView(
                      children: [
                        // first tab bar view widget
                        SingleChildScrollView(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('videos')
                                .where("isVisible", isEqualTo: "Public")
                                .where('channelId', whereIn: followersId)
                                .orderBy("date", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: primary,
                                    )));
                              }
                              if (snapshot.data.docs.isEmpty) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: Text("No videos to show!",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 15))));
                              }
                              if (snapshot.hasData) {
                                return new ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: snapshot.data.docs.map((doc) {
                                    Video videoItems =
                                        Video.fromMap(doc.data());
                                    return VideoCard(
                                      video: videoItems,
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: Text("Unknown Error Occured!",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 15))));
                              }
                            },
                          ),
                        ),

                        // second tab bar viiew widget
                        SingleChildScrollView(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("posts")
                                .where("isVisible", isEqualTo: "Public")
                                .where('channelId', whereIn: followersId)
                                .orderBy("date", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: primary,
                                    )));
                              }
                              if (snapshot.data.docs.isEmpty) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: Text("No posts to show!",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 15))));
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
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: Text("Unknown Error Occured!",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 15))));
                              }
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('reels')
                                .where('channelId', whereIn: followersId)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: primary,
                                    )));
                              }
                              if (snapshot.data.docs.isEmpty) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: Text("No 30s videos to show!",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 15))));
                              }
                              if (snapshot.hasData) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: primary),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowersShorts(
                                                        followersId)),
                                          );
                                        },
                                        child: Text(
                                          "View all 30s of your followers",
                                          style:
                                              GoogleFonts.ubuntu(fontSize: 15),
                                        ),
                                      ),
                                    ));
                              } else {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                        child: Text("Unknown Error Occured!",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 15))));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
