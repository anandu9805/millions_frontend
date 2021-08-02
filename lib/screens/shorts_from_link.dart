import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/size.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:millions/screens/uploadvideo.dart';
import 'package:millions/services/likeServices.dart';
import 'package:millions/widgets/reportReels.dart';
import '../model/reels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../services/dynamiclinkservice.dart';

class ShortsFromLink extends StatefulWidget {
  final String reelid;
  const ShortsFromLink({Key key, this.reelid}) : super(key: key);

  @override
  _ShortsFromLinkState createState() => _ShortsFromLinkState();
}

class _ShortsFromLinkState extends State<ShortsFromLink> {
  @override
  void initState() {
    print(
        "In shorts_from_link----------------------------------------------------");
    // print("going to call");

    GetCurrentUserDetails();

    getFollowingdetails();
    _getReels();

    super.initState();
  }

  List<DocumentSnapshot> _reels_items = [];
  int index = 0;
  var currentuserid = FirebaseAuth.instance.currentUser.uid; //the id of the logged in user
  // var currentuserid = "DEyDJLaskaSXV5kMBLXSGBBZC062";
  List following_details = [];
  bool liked = false;
  String likeId;
  var _isLoading = true;
  List parameters = ['30s'];
  String dynamic_link;

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
          if (doc['follower'] == currentuserid) {
            following_details.add(doc['channel']);
            print("following_details.add(doc['channel'])");
            print(following_details);
          }
        });
      });
    } catch (e) {
      return "Follow";
    }
  }

  _getReels() async {
    await FirebaseFirestore.instance
        .collection('reels')
        .doc(widget.reelid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      _reels_items.add(documentSnapshot);
    });
    setState(() {
      _isLoading = false;
    });
    print("_reels_items");
    print(_reels_items);
    print(" src: _reels_items[index][\"videoSrc\"] ");
    print(_reels_items[index]["videoSrc"]);
  }

  @override
  Widget build(BuildContext context) {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading == false
          ? Stack(children: [
              //  Text("hello"),
              ContentScreen(
                  src: _reels_items[index]
                      ["videoSrc"] //reels_objects[index].videoSrc,
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
                          _reels_items[index]["profilePic"],
                          //reels_objects[index].profilePic,
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
                          _reels_items[index]["channelName"],
                          //  reels_objects[index].channelName,
                          style: GoogleFonts.ubuntu(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        if (_reels_items[index]["isVerified"]
                        //reels_objects[index].isVerified
                        )
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
                    Row(
                      children: [
                        _reels_items[index]["channelId"] != currentuserid
                            ? FlatButton(
                                color: primary,
                                onPressed: () {
                                  if (!following_details
                                      .contains(_reels_items[index]["channelId"]
                                          // reels_objects[index].channelId
                                          )) {
                                    setState(() {
                                      following_details.add(
                                          _reels_items[index]["channelId"]);
                                    });
                                    FirebaseFirestore.instance
                                        .collection('followers')
                                        .doc(currentuserid)
                                        .set({
                                      'channel': _reels_items[index]
                                          ["channelId"],
                                      'date': DateTime.now(),
                                      'follower': currentuserid
                                    });
                                  } else {
                                    //                        print("already following");
                                  }
                                },
                                child: Text(
                                  !following_details.contains(
                                          _reels_items[index]["channelId"])
                                      ? 'Follow'
                                      : 'Following',
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      height: 1,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : FlatButton(
                                child: Text('Following'),
                                color: Colors.black12,
                              )
                      ],
                    ),
                    Text(
                      _reels_items[index]["description"],
                      // reels_objects[index].description,
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
                                  FirebaseAuth.instance.currentUser.uid);
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
                                        FirebaseAuth.instance.currentUser.uid);
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
                                        FirebaseAuth.instance.currentUser.uid);
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
                    SizedBox(height: 20),
                    IconButton(
                      onPressed: () async {
                        parameters = ['30s'];
                        parameters.add(widget.reelid);
                        print(parameters);
                        await _dynamicLinkService
                            .createDynamicLink(parameters)
                            .then((value) {
                          dynamic_link = value;
                        });
                        //here------------- ------------------    ---------------- -- --- --- --    ----   ---- --- -- -- - - - - - -----
                        Share.share(dynamic_link);
                      }, //reels share function
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportReels(
                                reels:
                                    Reels.fromMap(_reels_items[index].data()),
                              ),
                            ));
                      }, //reels report function
                      icon: Icon(
                        Icons.flag_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ])
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
