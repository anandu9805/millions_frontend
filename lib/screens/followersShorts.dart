import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/size.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/reelsLike.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:millions/screens/reelsComments.dart';
import 'package:millions/screens/uploadvideo.dart';
import 'package:millions/services/likeServices.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/widgets/reportReels.dart';
import 'package:numeral/numeral.dart';
import '../model/reels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../services/dynamiclinkservice.dart';

class FollowersShorts extends StatefulWidget {
 final List<String> followers;
  FollowersShorts(this.followers);
  @override
  _FollowersShortsState createState() => _FollowersShortsState();
}

class _FollowersShortsState extends State<FollowersShorts> {
  SwiperController _scrollController = SwiperController();

  //ScrollController _scrollController=ScrollController();
  var currentuserid =
      FirebaseAuth.instance.currentUser.uid; //the id of the logged in user
  // var currentuserid = "DEyDJLaskaSXV5kMBLXSGBBZC062";
  List following_details = [];

  bool liked = false;
  String likeId;
  var _perpage = 10;
  List<Reels> reels_objects = [];
  List<DocumentSnapshot> _reels_items = [];
  DocumentSnapshot _lastdocument;
  var _isLoading = true;
  int number_of_items, swiper_number_of_items;
  String dynamic_link;
  List parameters = ['30s'];

  @override
  void initState() {
    print("going to call");

    GetCurrentUserDetails();
    _getReels();
    getFollowingdetails();

    super.initState();
  }

  Future<String> GetCurrentUserDetails() async {
    //get current user details here
    try {
      print(
          "hello---------------------------------------------------------------------------------------------");
      await FirebaseFirestore.instance
          .collection('channels')
          .doc(currentuserid)
          .get()
          .then((value) => print(value));
    } catch (e) {
      return "Follow";
    }
  }

  Future<String> getFollowingdetails() async {
    try {
      //  print("hello");
      await FirebaseFirestore.instance
          .collection('followers')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          //  print("in");
          if (doc['follower'] == currentuserid)
            following_details.add(doc['channel']);
        });
      });
    } catch (e) {
      return "Follow";
    }
  }

  _getReels() async {
    Query q = FirebaseFirestore.instance
        .collection('reels')
        .where("channelId", whereIn:widget.followers)
        .orderBy("date", descending: true)
        .limit(_perpage);
    QuerySnapshot querySnapshot = await q.get();
    _reels_items = querySnapshot.docs;
    _lastdocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      _isLoading = false;
    });
    print("_getReels");
    print("_reels_items");
    print(_reels_items);
    number_of_items = _reels_items.length - 1;
    swiper_number_of_items = _reels_items.length;
  }

  _getMoreReels() async {
    print(_lastdocument.data());
    print(_lastdocument.id);
    Query q = FirebaseFirestore.instance
        .collection('reels')
        .where("channelId", whereIn:widget.followers)
        .orderBy("date")
        .startAfterDocument(_lastdocument);
    QuerySnapshot querySnapshot = await q.get();
    setState(() {
      swiper_number_of_items = _reels_items.length;
    });
    if (querySnapshot.docs.length == 0) {
      print("empty-------------------------------------------");
    } else {
      _lastdocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      _reels_items.addAll(querySnapshot.docs);
      print("_getMoreReels");
      print("_reels_items");
      print(_reels_items);
      number_of_items = _reels_items.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading == false
          ? Swiper(
              onIndexChanged: (int index) {
                print(
                    "--------------------------------------------------------------------------------------------");
                print(index);
                if (number_of_items - index == 2) {
                  print(
                      "Now going to get more items---------------------------------------------------------------");
                  _getMoreReels();
                }
              },
              controller: _scrollController,
              containerWidth: MediaQuery.of(context).size.width,
              itemBuilder: (BuildContext context, int index) {
                return Stack(children: [
                  ContentScreen(
                      src: _reels_items[index]
                          ["videoSrc"], //reels_objects[index].videoSrc,
                      cover: _reels_items[index]["thumbnail"]),
                  Positioned(
                    left: w / 30,
                    bottom: h / 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            _reels_items[index]["description"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            // reels_objects[index].description,
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                height: 1,
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            CircleAvatar(
                              child: ClipRRect(
                                child: Image.network(
                                  _reels_items[index]["profilePic"],
                                  //reels_objects[index].profilePic,
                                  width: w * 0.5,
                                  height: h * 0.5,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(w * 1),
                              ),
                              radius: 14,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: h * 0.27),
                              padding: EdgeInsets.only(right: 1.0),
                              child: Text(
                                _reels_items[index]["channelName"],
                                //  reels_objects[index].channelName,
                                style: GoogleFonts.ubuntu(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 1),
                            if (_reels_items[index]["isVerified"]
                            //reels_objects[index].isVerified
                            )
                              Icon(
                                Icons.verified,
                                size: 15,
                                color: Colors.blue,
                              ),
                            SizedBox(width: 2),
                            _reels_items[index]["channelId"] != currentuserid
                                ? TextButton(
                              onPressed: () async {
                                if (!following_details.contains(
                                    _reels_items[index]["channelId"]
                                  // reels_objects[index].channelId
                                )) {
                                  setState(() {
                                    following_details.add(
                                        _reels_items[index]["channelId"]);
                                  });
                                  var docId=currentuserid +
                                      "_" +
                                      _reels_items[index]["channelId"];
                                  await FirebaseFirestore.instance
                                      .collection('followers')
                                      .doc(docId)
                                      .set({
                                    'channel': _reels_items[index]
                                    ["channelId"],
                                    'date': DateTime.now(),
                                    'follower': currentuserid
                                  });
                                } else  {

                                  var docId=currentuserid +
                                      "_" +
                                      _reels_items[index]["channelId"];
                                  // print("already following");
                                  try {
                                    await FirebaseFirestore.instance
                                        .doc("followers/$docId")
                                        .delete()
                                        .whenComplete(() {
                                      setState(() {
                                        following_details.remove(
                                            _reels_items[index]["channelId"]);
                                      });


                                      // checkExist(widget.channelId);
                                    }).catchError(
                                            (error) => print("error"));
                                  } catch (e) {
                                    print("Error");
                                  }





                                }
                              },//-----------------------------
                                    child: Text(
                                      following_details.contains(
                                              _reels_items[index]["channelId"])
                                          ? '• Following'
                                          : '• Follow',
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          height: 1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () {  },
                                    child: Text(
                                      '• Following',
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          height: 1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                          ],
                        ),
                        Row(
                          children: [],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: w / 80,
                    bottom: h / 7,
                    child: Column(
                      children: [
                        // liked == true
                        //     ? IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             liked = !liked;
                        //           });
                        //           LikeServices().unLikeReels(
                        //               _reels_items[index]["id"],
                        //               // reels_objects[index].id,
                        //               currentuserid,
                        //               currentuserid);
                        //         }, //---------------------------------------------------
                        //         icon: Icon(
                        //           Icons.favorite_rounded,
                        //           color: Colors.white,
                        //         ),
                        //       )
                        //     : IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             liked = !liked;
                        //           });
                        //           LikeServices().likeReels(
                        //               _reels_items[index]["id"],
                        //               _reels_items[index]["channelId"],
                        //               currentuserid);
                        //         }, //----------------------
                        //         icon: IconButton(
                        //           icon: Icon(Icons.favorite_outline_rounded),
                        //           color: Colors.white,
                        //           onPressed: () {
                        //             print("index");
                        //             print(index);
                        //           },
                        //         ),
                        //       ),
                        Column(children: [
                          FutureBuilder(
                            future: LikeServices()
                                .reelsLikeChecker(_reels_items[index]["id"]),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      liked = !liked;
                                    });
                                    print(_reels_items[index]["id"] +
                                        _reels_items[index]["channelId"] +
                                        altUserId);
                                    LikeServices().likeReels(
                                        _reels_items[index]["id"],
                                        _reels_items[index]["channelId"],
                                        FirebaseAuth.instance.currentUser.uid);
                                  },
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: primary,
                                  ),
                                );
                              } else {
                                // liked = ReelsLike.fromDoc(snapshot.data);
                                print(snapshot.data);
                                liked = snapshot.data;
                                // ReelsLike likeDetails =
                                //     ReelsLike.fromMap(snapshot.data);
                                // print(likeDetails.liked);
                                return liked == true
                                    ? IconButton(
                                        onPressed: () {
                                          print("disliked");
                                          setState(() {
                                            liked = !liked;
                                          });
                                          print(liked);
                                          LikeServices().unLikeReels(
                                              _reels_items[index]["id"],
                                              _reels_items[index]["channelId"],
                                              FirebaseAuth
                                                  .instance.currentUser.uid);
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: primary,
                                        ),
                                      )
                                    :
                                    // } else {
                                    // return
                                    IconButton(
                                        onPressed: () {
                                          print("like");
                                          setState(() {
                                            liked = !liked;
                                          });
                                          print(liked);
                                          // print(_reels_items[index].id +
                                          //     _reels_items[index].channelId +
                                          //     altUserId);
                                          LikeServices().likeReels(
                                              _reels_items[index]["id"],
                                              _reels_items[index]["channelId"],
                                              FirebaseAuth
                                                  .instance.currentUser.uid);
                                        },
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: primary,
                                        ),
                                      );
                              }
                              // }
                            },
                          ),
                          Text(
                            Numeral(_reels_items[index]["likes"]).value(),
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                height: 1,
                                fontWeight: FontWeight.w100),
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            onPressed: () async {
                              parameters = ['30s'];
                              parameters.add(_reels_items[index]["id"]);
                              print(parameters);
                              await _dynamicLinkService
                                  .createDynamicLink(parameters)
                                  .then((value) {
                                dynamic_link = value;
                              });
                              //here------------- ------------------    ---------------- -- --- --- --    ----   ---- --- -- -- - - - - - -----
                              Share.share(dynamic_link);

                              //-----------------------------
                            }, //reels share function
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportReels(
                                      reels: Reels.fromMap(
                                          _reels_items[index].data()),
                                    ),
                                  ));
                            }, //reels report function
                            icon: Icon(
                              Icons.flag_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShortsComments(
                                            commentId: _reels_items[index]
                                                ["id"],
                                            post: Reels.fromMap(
                                              _reels_items[index].data(),
                                            ),
                                          )));
                            }, //reels report function
                            icon: Icon(
                              Icons.comment_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ])
                      ],
                    ),
                  ),
                ]);
              },
              // autoplay: true,
              //  itemWidth:DeviceSize(context).width*0.5,
              itemCount: swiper_number_of_items = _reels_items.length,
              scrollDirection: Axis.vertical,
              //loop: false,
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              ),
            ),
    );
  }
}

/**/
