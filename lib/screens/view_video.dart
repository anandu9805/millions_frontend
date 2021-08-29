import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_ago/flutter_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';

import 'package:millions/model/comment_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/comment_screen.dart';
import 'package:millions/screens/home.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/searchPage..dart';
import 'package:millions/services/commentServices.dart';
import 'package:millions/services/likeServices.dart';
import 'package:millions/services/report-services.dart';
import 'package:millions/widgets/ads.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/widgets/playVideo.dart';
import 'package:millions/widgets/reportVideo.dart';
import 'package:millions/widgets/videoCard.dart';

import 'package:share_plus/share_plus.dart';
import '../constants/colors.dart';

import '../services/dynamiclinkservice.dart';
import '../services/userService.dart';

class ReasonList {
  String reason;
  int index;

  ReasonList({this.reason, this.index});
}

enum SingingCharacter { lafayette, jefferson }

// In the State of a stateful widget:

class ViewVideo extends StatefulWidget {
  final Video video;
  final String id;

  const ViewVideo({Key key, this.video, this.id}) : super(key: key);

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
//---------------------

  String followStatus = "Follow";
  Future<String> checkExist(String docID) async {
    try {
      await FirebaseFirestore.instance
          .doc("followers/$docID")
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            followStatus = "Unfollow";
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
        _showToast(context, "UnFollowed " +  widget.id!=null?video2.channelName: widget.video.channelName);
        FirebaseMessaging.instance
            .unsubscribeFromTopic(widget.id!=null?video2.channelId: widget.video.channelId);
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
        _showToast(context, "Following " + widget.id!=null?video2.channelName: widget.video.channelName);
        FirebaseMessaging.instance.subscribeToTopic(widget.id!=null?video2.channelId: widget.video.channelId);
        setState(() {
          followStatus = "Unfollow";
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

  Stream<QuerySnapshot<Map<String, dynamic>>> recommendedStream;
//---------------------

  Video video2 = null;

  FlickManager flickManager;
  bool playState = false;
  bool liked = false;
  String likeId;
  String userId = "XIi08ww5Fmgkv7FXOSTkOcmVh2C3";

  var _isLoading = true;

  List<String> reasons = [
    "Spam Content",
    "Explicit or Sexual Content",
    "Child Abuse",
    "Against law",
    "Harassment or bullying"
  ];

  String dynamic_link;

  List parameters = ['watch'];

  int value;
  bool flag = true;

  // String timeAgo(DateTime d) {
  //   Duration diff = DateTime.now().difference(d);
  //   if (diff.inDays > 365)
  //     return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  //   if (diff.inDays > 30)
  //     return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  //   if (diff.inDays > 7)
  //     return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  //   if (diff.inDays > 0)
  //     return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  //   if (diff.inHours > 0)
  //     return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  //   if (diff.inMinutes > 0)
  //     return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  //   return "just now";
  // }

  _getVideoFromId() //to get the video from the id passed through the dynamic link
  async {
    await FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      video2 = Video.fromMap(documentSnapshot.data());
          recommendedStream = FirebaseFirestore.instance
        .collection("videos")
        .where("isVisible", isEqualTo: "Public")
        .where("category", whereIn: [video2.category,"Vlog"])
        .limit(5)
        .snapshots();
         checkExist(altUserId + "_" +video2.channelId)
        .then((value) => followStatus = value);
    });
    setState(() {
      _isLoading = false;
    });
    print('video2');
    print(video2);
    print(video2.id);
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.id != null && widget.video == null) {
      //_isLoading=true;
      _getVideoFromId(); //to get the video from the id passesd through the dynamic link

    } else {
      recommendedStream = FirebaseFirestore.instance
        .collection("videos")
        .where("isVisible", isEqualTo: "Public")
        .where("category", whereIn: [widget.video.category,"Vlog"])
        .limit(5)
        .snapshots();
         checkExist(altUserId + "_" +widget.video.channelId)
        .then((value) => followStatus = value);
      likeId = widget.id == null
          ? userId + '_' + widget.video.id
          : userId + '_' + video2.id;

      Future<DocumentSnapshot> likedData = LikeServices().likeChecker(likeId);
      likedData.then((value) {
        setState(() {
          liked = value.get('liked') || false;
          liked = liked ?? false;
        });
      });

      
    }
    
   
  }

  int selected = -1;

  @override
  void dispose() {
    // flickManager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
       
        body: (_isLoading == false || widget.id == null)
            ? SingleChildScrollView(
                child: Flex(direction: Axis.horizontal, children: [
                  (widget.video!=null&& widget.video.isVisible == "Public") ||(widget.id!=null && video2.isVisible == "Public")
                      ? Expanded(
                          child: Column(
                            children: [
                              PlayVideo(
                                video:
                                    widget.id == null ? widget.video : video2,
                                duration: widget.id == null
                                    ? widget.video.duration * 1.0
                                    : video2.duration * 1.0,
                              ),
                              Column(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RichText(
                                        text: TextSpan(
                                            text: widget.id == null
                                                ? widget.video.title + '\n'
                                                : video2.title + '\n',
                                            style: GoogleFonts.ubuntu(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 18,
                                                height: 1.5),
                                            children: [
                                              TextSpan(
                                                text: widget.id == null
                                                    ? widget.video.description
                                                    : video2.description,
                                                style: GoogleFonts.ubuntu(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ]),
                                        maxLines: flag ? 2 : 100,
                                      ),

                                      // ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          splashRadius: 2,
                                          icon: Icon(flag
                                              ? Icons.keyboard_arrow_down_sharp
                                              : Icons.keyboard_arrow_up_sharp),
                                          onPressed: () {
                                            setState(() {
                                              flag = !flag;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "${widget.id == null ? widget.video.views : video2.views} views • ${widget.id == null ? FlutterTimeAgo.parse(widget.video?.date.toDate(), lang: 'en') : FlutterTimeAgo.parse(video2?.date.toDate(), lang: 'en')}",
                                      style: GoogleFonts.ubuntu(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      liked == true
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  liked = !liked;
                                                });
                                                LikeServices().unLikeVideo(
                                                    widget.id == null
                                                        ? widget.video.id
                                                        : video2.id,
                                                    userId,
                                                    altUserId);
                                              }, //---------------------------------------------------
                                              icon: Icon(
                                                Icons.thumb_up,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  liked = !liked;
                                                });
                                                LikeServices().likeVideo(
                                                    widget.id == null
                                                        ? widget.video.id
                                                        : video2.id,
                                                    userId,
                                                    userId);
                                              }, //----------------------
                                              icon: Icon(
                                                Icons.thumb_up_alt_outlined,
                                              ),
                                            ),
                                      FutureBuilder(
                                          future: LikeServices().videoLikeCount(
                                              widget.id == null
                                                  ? widget.video.id
                                                  : video2.id),
                                          builder: (context, snapshot) {
                                            return Text(
                                              "${snapshot.data}",
                                              style: GoogleFonts.ubuntu(
                                                  height: 0.3, fontSize: 10),
                                            );
                                          })
                                    ],
                                  ),
                                  // Column(
                                  //   children: [
                                  //     IconButton(
                                  //       onPressed: () {
                                  //         LikeServices()
                                  //             .unLikeVideo(widget.video.id, userId, userId);
                                  //       },
                                  //       icon: Icon(Icons.thumb_down),
                                  //     ),
                                  //     Text(
                                  //       "${widget.video.disLikes}",
                                  //       style: TextStyle(height: 0.3, fontSize: 10),
                                  //     )
                                  //   ],
                                  // ),

                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if ((widget.video!=null && widget.video.isComments ==
                                              'Allowed') || (widget.id!=null && video2.isComments=="Allowed")){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Comments(
                                                  videoId: widget.id == null
                                                      ? widget.video.id
                                                      : video2.id.toString(),
                                                  video: widget.id == null
                                                      ? widget.video
                                                      : video2,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.comment_outlined,
                                        ),
                                      ),
                                      Text(
                                      (widget.video!=null &&  widget.video.isComments == 'Allowed') ||(widget.id!=null && video2.isComments=="Allowed")
                                            ? "${widget.id == null ? widget.video.comments : video2.comments}"
                                            : "Disabled",
                                        style: GoogleFonts.ubuntu(
                                            height: 0.3, fontSize: 10),
                                      )
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          print("clicking share videos");
                                          parameters = ['watch'];
                                          parameters.add(
                                            widget.id == null
                                                ? widget.video.id
                                                : video2.id,
                                          );
                                          print(parameters);
                                          await _dynamicLinkService
                                              .createDynamicLink(parameters)
                                              .then((value) {
                                            dynamic_link = value;
                                          });
                                          //here------------- ------------------    ---------------- -- --- --- --    ----   ---- --- -- -- - - - - - -----
                                          Share.share(dynamic_link);
                                        },
                                        icon: Icon(
                                          Icons.share,
                                        ),
                                      ),
                                      Text(
                                        "Share",
                                        style: GoogleFonts.ubuntu(
                                            height: 0.3, fontSize: 10),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportPage(
                                                  video: widget.video,
                                                ),
                                              ));
                                          // reportPopUp(h, context);
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) {
                                          //       return Container(
                                          //         child: Column(
                                          //           children: [
                                          //             SimpleDialog(
                                          //               title: Row(
                                          //                 mainAxisAlignment:
                                          //                     MainAxisAlignment.spaceBetween,
                                          //                 children: <Widget>[
                                          //                   Column(
                                          //                     children: nList
                                          //                         .map((data) =>
                                          //                             RadioListTile(
                                          //                               title: Text(
                                          //                                   "${data.reason}"),
                                          //                               groupValue: id,
                                          //                               value: data.index,
                                          //                               onChanged: (val) {
                                          //                                 setState(() {
                                          //                                   radioItemHolder =
                                          //                                       data.reason;
                                          //                                   id = data.index;
                                          //                                 });
                                          //                               },
                                          //                             ))
                                          //                         .toList(),
                                          //                   ),
                                          //                   new ElevatedButton(
                                          //                     onPressed: () {
                                          //                       ReportServices().reportVideo(
                                          //                           widget.video,
                                          //                           radioItemHolder);
                                          //                     },
                                          //                     child: new Text(
                                          //                       "Done",
                                          //                       style: TextStyle(
                                          //                           color: Colors.white),
                                          //                     ),
                                          //                   )
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       );
                                          //     });
                                        },
                                        icon: Icon(Icons.flag_outlined),
                                      ),
                                      Text(
                                        "Report",
                                        style: GoogleFonts.ubuntu(
                                            height: 0.3, fontSize: 10),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 10,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Page8(
                                                      widget.id == null
                                                          ? widget
                                                              .video.channelId
                                                          : video2.channelId)),
                                            );
                                          },
                                          child: FutureBuilder(
                                              future: UserServices()
                                                  .getUserDetails(widget.id ==
                                                          null
                                                      ? widget.video.channelId
                                                      : video2.channelId),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return CircleAvatar(
                                                    child: ClipRRect(
                                                      child: Image.network(
                                                        snapshot.data
                                                            .toString(),
                                                        //reels_objects[index].profilePic,
                                                        width: w * 1,
                                                        height: h * 1,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              w * 0.5),
                                                    ),
                                                    //sradius: 18,
                                                  );
                                                } else {
                                                  return CircleAvatar(
                                                    // radius: w * 0.05,
                                                    backgroundColor:
                                                        Colors.black,
                                                  );
                                                }
                                              }),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "${widget.id == null ? widget.video.channelName : video2.channelName}",

                                          //content[this.widget.index].userName,
                                          style: GoogleFonts.ubuntu(
                                              color: Colors.black,
                                              fontSize: 15,
                                              height: 1.2,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (widget.id == null
                                            ? widget.video.isVerified
                                            : video2.isVerified)
                                          Icon(
                                            Icons.verified,
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                      ],
                                    ),
                                  (widget.id==null? widget.video.channelId : video2.channelId) != altUserId
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (followStatus == "Unfollow")
                                                  unfollow(altUserId +
                                                      "_" +
                                                     widget.id!=null?video2.channelId: widget.video.channelId);
                                                else {
                                                  Map details = {
                                                    'channel':
                                                       widget.id!=null?video2.channelId: widget.video.channelId,
                                                    'date': FieldValue
                                                        .serverTimestamp(),
                                                    'follower': altUserId
                                                  };
                                                  follow(
                                                      altUserId +
                                                          "_" +
                                                          widget.id!=null?video2.channelId: widget.video.channelId,
                                                      details);
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: primary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              // width: MediaQuery.of(context).size.width * 0.1,
                                              //color: primary,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    "$followStatus",
                                                    style: GoogleFonts.ubuntu(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 10,
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(left: 10, right: 10),
                              //   child: widget.video.isComments == 'Allowed'
                              //       ? Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               "${widget.id == null ? widget.video.comments : video2.comments} Comments",
                              //               style: GoogleFonts.ubuntu(),
                              //             ),
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.push(
                              //                   context,
                              //                   MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         Comments(
                              //                       videoId: widget.id == null
                              //                           ? widget.video.id
                              //                           : video2.id.toString(),
                              //                       video: widget.id == null
                              //                           ? widget.video
                              //                           : video2,
                              //                     ),
                              //                   ),
                              //                 );
                              //               },
                              //               child: Text(
                              //                 "View Comments",
                              //                 style: GoogleFonts.ubuntu(
                              //                     height: 1, color: primary),
                              //               ),
                              //             ),
                              //           ],
                              //         )
                              //       : Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text("Comments are disabled"),
                              //             Icon(Icons.comment_outlined),
                              //           ],
                              //         ),
                              // ),
                              Container(
                                width: double.infinity,
                                child: AdPost(),
                              ),
                               SizedBox(
                                height: 10,
                              ),
                              StreamBuilder(
                                stream: recommendedStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.25,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator(
                                          color: primary,
                                        )));
                                  }
                                  
                                 else if (snapshot.hasData) {
                                    return new ListView(
                                      physics:
                                          NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children:
                                          snapshot.data.docs.map((doc) {
                                        Video videoItems =
                                            Video.fromMap(doc.data());
                                        return VideoCard(
                                          video: videoItems,
                                          fromwhere: 1,
                                        );
                                      }).toList(),
                                    );
                                  } else {
                                    return Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.25,
                                        child: Center(
                                            child: Text(
                                                "Unknown Error Occured!",
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 15))));
                                  }
                                },
                              )
                              ],)
                            ],
                          ),
                        )
                      : Container(
                          // height: MediaQuery.of(context).size.height *
                          //     0.25,
                          width: MediaQuery.of(context).size.width,
                          child: Column(children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Image.asset(
                              'images/error.png',
                              width: MediaQuery.of(context).size.width * 0.6,
                              // height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Center(
                                child: Text(
                              "Video " + widget.video.isVisible,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                color: Colors.black87,
                                // fontWeight: FontWeight.bold
                              ),
                            )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Center(
                                child: Text(
                              "Video is currently " +
                                  widget.video.isVisible +
                                  ". Please come back later.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ubuntu(
                                fontSize: 10,
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold
                              ),
                            )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: primary, elevation: 0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                },
                                child: Text(
                                  "Go Home",
                                  style: GoogleFonts.ubuntu(fontSize: 15),
                                ),
                              ),
                            )
                          ])),
                ]),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: primary,
                  ),
                ),
              ),
      ),
    );
  }
}
