import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/user.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:millions/widgets/photos.dart';


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
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
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
              CollectionReference channels =
                  FirebaseFirestore.instance.collection('channels');
              return Column(
                children: [
                  Row(
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
                                    ConnectionState.done) {
                                  //   flag=1;
                                  channeldata = snapshot.data.data()
                                      as Map<String, dynamic>;

                                  return Row(children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
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
                                        Text(channeldata['channelName'],
                                            style: GoogleFonts.ubuntu())
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ]);
                                }

                                return Center(
                                    child: Text("Loading Following Channels..",
                                        style:
                                            GoogleFonts.ubuntu(fontSize: 15)));
                              },
                            );
                          },
                          itemCount: d.length,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 9, left: 5),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Follow',
                          style: GoogleFonts.ubuntu(
                              fontSize: 25, color: Colors.black54),
                        )),
                  ),
                  followersId.isNotEmpty
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("posts")
                              .where("isVisible", isEqualTo: "Public")
                              .where('channelId', whereIn: followersId)
                              .orderBy("date", descending: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              //print(snapshot.data.size);
                              return ListView(
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
                              print(123);
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: primary,
                                  ),
                                ),
                              );
                            }
                          },
                          // future: VideoServices.getAllVideos(),
                        )
                      : Text(""),
                  followersId.isNotEmpty
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('videos')
                              .where("isVisible", isEqualTo: "Public")
                              .where('channelId', whereIn: followersId)
                              .orderBy("date", descending: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
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
                              print(123);
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: primary,
                                  ),
                                ),
                              );
                            }
                          },
                          // future: VideoServices.getAllVideos(),
                        )
                      : Text('')
                ],
              );
            } else {
              return CircularProgressIndicator(
                color: primary,
              );
            }
          },
        ),
      ),
    );
  }
}
