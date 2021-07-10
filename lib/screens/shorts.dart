import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/size.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../model/reels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';
import './like_icon.dart';
import './options_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Shorts extends StatefulWidget {
  // final List<String> videos = [
  //   // 'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
  //   // 'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
  //   // 'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
  //   // 'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
  //   // 'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
  //   // 'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
  //   // 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  // ];

  @override
  _ShortsState createState() => _ShortsState();
}

class _ShortsState extends State<Shorts> {
   var currentuserid =
       "4C4iLByizTPLBBlP4rssrwGTISb2"; //the id of the logged in user
 // var currentuserid = "DEyDJLaskaSXV5kMBLXSGBBZC062";
  List following_details = [];

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
          print("in");
          if (doc['follower'] == currentuserid)
            following_details.add(doc['channel']);
        });
        print("followerdetails:");
        print(following_details);
      });
      // await FirebaseFirestore.instance
      //     .doc("followers/$docID")
      //     .get()
      //     .then((doc) {
      //   if (doc.exists)
      //     followStatus = "Unfollow";
      //   else
      //     followStatus = "Follow";
      // });
      // return followStatus;
    } catch (e) {
      return "Follow";
    }
  }

  List<Reels> reels_objects = [];

  @override
  Widget build(BuildContext context) {
    // print("Followingdetails:");
    // print(following_details);

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reels').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                        Row(
                          children: [
                            FlatButton(
                              color: primary,
                              onPressed: () {
                                if (!following_details
                                    .contains(reels_objects[index].channelId)) {
                                  setState(() {
                                    following_details
                                        .add(reels_objects[index].channelId);
                                  });
                                  FirebaseFirestore.instance
                                      .collection('followers')
                                      .doc(currentuserid)
                                      .set({
                                    'channel': reels_objects[index].channelId,
                                    'date': DateTime.now(),
                                    'follower': currentuserid
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
                        ),
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
                    right: w/80,
                    bottom: h / 7,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: (){},//reels like function
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        IconButton(onPressed: (){},//reels share function
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: (){},//reels report function
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
