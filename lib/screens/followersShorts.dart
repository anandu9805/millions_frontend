import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/size.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:millions/services/likeServices.dart';
import 'package:numeral/numeral.dart';
import '../model/reels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';

import 'package:google_fonts/google_fonts.dart';

class FollowersShorts extends StatefulWidget {
  List followers;
  FollowersShorts(this.followers);
  @override
  _FollowersShortsState createState() => _FollowersShortsState();
}

class _FollowersShortsState extends State<FollowersShorts> {
  var currentuserid = FirebaseAuth.instance.currentUser.uid;
  List following_details = [];
  bool liked;
  String likeId;

  @override
  void initState() {
    getFollowingdetails();
    super.initState();
  }

  Future<String> getFollowingdetails() async {
    try {
      FirebaseFirestore.instance
          .collection('followers')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          // print("in");
          if (doc['follower'] == altUserId)
            following_details.add(doc['channel']);
        });
        // print("followerdetails:");
        // print(following_details);
      });
    } catch (e) {
      return "Follow";
    }
  }

  List<Reels> reels_objects = [];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reels')
            .where('channelId', whereIn: widget.followers)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // print("has data");
            reels_objects = snapshot.data.docs.map((doc) {
              Reels reelsItems = Reels.fromMap(doc.data());

              return reelsItems;
            }).toList();
            // print(reels_objects);

            return Swiper(
              containerWidth: MediaQuery.of(context).size.width,
              itemBuilder: (BuildContext context, int index) {
                // print("reels_objects[index].videoSrc");
                // print(reels_objects[index].videoSrc);

                return Stack(children: [
                  ContentScreen(
                      src: reels_objects[index].videoSrc,
                      cover: reels_objects[index].thumbnailUrl),
                  Positioned(
                    left: w / 30,
                    bottom: h / 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            reels_objects[index].description,
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
                                  reels_objects[index].profilePic,
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
                                reels_objects[index].channelName,
                                //  reels_objects[index].channelName,
                                style: GoogleFonts.ubuntu(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 1),
                            if (reels_objects[index].isVerified
                            //reels_objects[index].isVerified
                            )
                              Icon(
                                Icons.verified,
                                size: 15,
                                color: Colors.blue,
                              ),
                            SizedBox(width: 2),
                            reels_objects[index].channelId != currentuserid
                                ? TextButton(
                                    onPressed: () {
                                      if (!following_details.contains(
                                          reels_objects[index].channelId
                                          // reels_objects[index].channelId
                                          )) {
                                        setState(() {
                                          following_details.add(
                                              reels_objects[index].channelId);
                                        });
                                        FirebaseFirestore.instance
                                            .collection('followers')
                                            .doc(currentuserid)
                                            .set({
                                          'channel':
                                              reels_objects[index].channelId,
                                          'date': DateTime.now(),
                                          'follower': currentuserid
                                        });
                                      } else {
                                        //                        print("already following");
                                      }
                                    },
                                    child: Text(
                                      !following_details.contains(
                                              reels_objects[index].channelId)
                                          ? '• Follow'
                                          : '• Following',
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          height: 1,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                : TextButton(
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
                        Column(children: [
                          FutureBuilder(
                            future: LikeServices()
                                .reelsLikeChecker(reels_objects[index].id),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      liked = !liked;
                                    });
                                    print(reels_objects[index].id +
                                        reels_objects[index].channelId +
                                        altUserId);
                                    LikeServices().likeReels(
                                        reels_objects[index].id,
                                        reels_objects[index].channelId,
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
                                              reels_objects[index].id,
                                              reels_objects[index].channelId,
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
                                          // print( reels_objects[index]..id +
                                          //      reels_objects[index]..channelId +
                                          //     altUserId);
                                          LikeServices().likeReels(
                                              reels_objects[index].id,
                                              reels_objects[index].channelId,
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
                            Numeral(reels_objects[index].likes).value(),
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                height: 1,
                                fontWeight: FontWeight.w100),
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
                            onPressed: () {}, //reels report function
                            icon: Icon(
                              Icons.flag_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ]),
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
                          onPressed: () {}, //reels report function
                          icon: Icon(
                            Icons.flag_outlined,
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
