import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/admodel.dart';
import 'package:millions/model/video.dart';
import 'package:millions/services/video-services.dart';
import 'package:millions/widgets/ads.dart';

import 'package:millions/widgets/videoCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../services/userService.dart';

class Screen5 extends StatefulWidget {
   int flag=0;//0 means home page and 1 means explore page
  @override
  _Screen5State createState() => _Screen5State();
  Screen5(int f)
  {
    this.flag=f;
  }
}

class _Screen5State extends State<Screen5> {
  List<DocumentSnapshot> _videos = [];
  bool _loadingVideos = true,
      _gettingMoreVideos = false,
      _moreVideosAvailable = true;
  int _perPage = 10;
  DocumentSnapshot _lastDocument;

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  _getVideos() async {
    Query q = FirebaseFirestore.instance
        .collection("videos")
        .where("isVisible", isEqualTo: "Public")
        .orderBy(widget.flag==0?"date":"videoScore", descending: true)
        .limit(_perPage);

    setState(() {
      _loadingVideos = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _videos = querySnapshot.docs;
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      _loadingVideos = false;
    });
  }

  _getMoreVideos() async {
    print("Hello from getmorevideos");
    if (!_moreVideosAvailable) {
      print("No more products");
      return;
    }
    if (_gettingMoreVideos) {
      return;
    }

    _gettingMoreVideos = true;
    Query q = FirebaseFirestore.instance
        .collection("videos")
        .where("isVisible", isEqualTo: "Public")
         .orderBy(widget.flag==0?"date":"videoScore", descending:true)
        .limit(_perPage)
        .startAfterDocument(_lastDocument);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < _perPage) {
      _moreVideosAvailable = false;
    }
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _videos.addAll(querySnapshot.docs);

    setState(() {
      _gettingMoreVideos = false;
    });
  }

  @override
  void initState() {
    super.initState();

    UserServices().getUserDetails('XIi08ww5Fmgkv7FXOSTkOcmVh2C3');
    _getVideos();
    _scrollController2.addListener(() {
      double maxScroll = _scrollController2.position.maxScrollExtent;
      double currentScroll = _scrollController2.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll > delta) {
        _getMoreVideos();
      }
    });
  }

  // getMoreVideos() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   if(l)
  // }

  @override
  Widget build(BuildContext context) {
    // final currentuser=FirebaseAuth.instance.currentUser;
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // final currentUserDetails =users.where('email',isEqualTo:currentuser.email );

    // var ifphotos = true;
    var h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      controller: _scrollController2,
      child: Column(
        children: [
          if(widget.flag==0)
          Container(
            child: AdPost(),
          ),
          if(widget.flag==0)
          SizedBox(height: 10,),

          _loadingVideos
              ? Center(
                  child: Container(
                  child: CircularProgressIndicator(
                    color: primary,
                  ),
                ))
              : _videos.length == 0
                  ? Center(
                      child: Container(
                      child: Text('No videos to show!',
                          style: GoogleFonts.ubuntu(fontSize: 15)),
                    ))
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _videos.length,
                          controller: _scrollController,
                          itemBuilder: (BuildContext ctx, int index) {
                            return VideoCard(
                                video: Video.fromMap(_videos[index].data()));
                          },
                        )
                      ],
                    ),
          // FutureBuilder(
          //   future: FirebaseFirestore.instance.collection('videos').get(),
          //   builder:
          //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.hasData) {
          //       return ListView(
          //         physics: NeverScrollableScrollPhysics(),
          //         shrinkWrap: true,
          //         controller: _scrollController,
          //         children: snapshot.data.docs.map((doc) {
          //           Video videoItems = Video.fromMap(doc.data());
          //           return VideoCard(
          //             video: videoItems,
          //           );
          //         }).toList(),
          //       );
          //     } else {
          //       return Container(
          //         child: Center(
          //           child: CircularProgressIndicator(),
          //         ),
          //       );
          //     }
          //   },
          //   // future: VideoServices.getAllVideos(),
          // ),
        ],
      ),
    );
  }
}