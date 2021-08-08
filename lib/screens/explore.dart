import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/widgets/photos.dart';
import 'package:millions/widgets/videoCard.dart';

class Explore extends StatefulWidget {
  const Explore({Key key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Explore",
          style: GoogleFonts.ubuntu(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('videos')
                        .where("isVisible", isEqualTo: "Public")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Center(
                                child: Text("No videos to show!",
                                    style: GoogleFonts.ubuntu(fontSize: 15))));
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
                                    style: GoogleFonts.ubuntu(fontSize: 15))));
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
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Center(
                                child: Text("No posts to show!",
                                    style: GoogleFonts.ubuntu(fontSize: 15))));
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
                                    style: GoogleFonts.ubuntu(fontSize: 15))));
                      }
                    },
                  ),
                ),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
