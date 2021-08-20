import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  _getVideoFromId() //to get the video from the id passed through the dynamic link
  async {
    await FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      video2 = Video.fromMap(documentSnapshot.data());
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
    if (widget.id != null && widget.video == null) {
      //_isLoading=true;
      _getVideoFromId(); //to get the video from the id passesd through the dynamic link

    } else {
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

      super.initState();
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
        appBar: widget.video.isVisible != "Public"
            ? AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              )
            : null,
        body: (_isLoading == false || widget.id == null)
            ? SingleChildScrollView(
                child: Flex(direction: Axis.horizontal, children: [
                  widget.video.isVisible == "Public"
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
                                      "${widget.id == null ? widget.video.views : video2.views} views • ${widget.id == null ? timeAgo(DateTime.fromMicrosecondsSinceEpoch(widget.video.date.microsecondsSinceEpoch)) : timeAgo(DateTime.fromMicrosecondsSinceEpoch(video2.date.microsecondsSinceEpoch))}",
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Page8(widget.id ==
                                                                  null
                                                              ? widget.video
                                                                  .channelId
                                                              : video2
                                                                  .channelId)),
                                                );
                                              },
                                              child:
                                                  // CircleAvatar(
                                                  //   child: ClipRRect(
                                                  //     child: Image.network(
                                                  //       FirebaseAuth.instance.currentUser
                                                  //           .photoURL,
                                                  //       fit: BoxFit.cover,
                                                  //     ),
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(w * 0.1),
                                                  //   ),
                                                  //   //backgroundColor: Colors.black,
                                                  // ),
                                                  FutureBuilder(
                                                      future: UserServices()
                                                          .getUserDetails(widget
                                                                      .id ==
                                                                  null
                                                              ? widget.video
                                                                  .channelId
                                                              : video2
                                                                  .channelId),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return CircleAvatar(
                                                            child: ClipRRect(
                                                              child:
                                                                  Image.network(
                                                                snapshot.data
                                                                    .toString(),
                                                                //reels_objects[index].profilePic,
                                                                width: w * 1,
                                                                height: h * 1,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          w * 0.5),
                                                            ),
                                                            radius: 17,
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
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.37),

                                                      // alignment: Alignment.bottomLeft,
                                                      padding: EdgeInsets.only(
                                                          right: 1.0),
                                                      child: Text(
                                                        "${widget.id == null ? widget.video.channelName : video2.channelName}",

                                                        //content[this.widget.index].userName,
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                height: 1.2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    if (widget.id == null
                                                        ? widget
                                                            .video.isVerified
                                                        : video2.isVerified)
                                                      Icon(
                                                        Icons.verified,
                                                        size: 20,
                                                        color: Colors.blue,
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 8.0),
                                  //   child: Column(
                                  //     children: [
                                  //       TextButton(
                                  //         onPressed: () {},
                                  //         child: Text("Following"),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 10,
                              ),
                              Container(
                                //height: MediaQuery.of(context).size.height * 1 / 14,
                                width: double.infinity,
                                child: AdPost(),
                                // child: Text(
                                //   'Add banner comes here',
                                //   style: TextStyle(color: Colors.white),
                                // ),
                                //color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.video.isComments == 'Allowed'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.id == null ? widget.video.comments : video2.comments} Comments",
                                            style: GoogleFonts.ubuntu(),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Comments(
                                                    videoId: widget.id == null
                                                        ? widget.video.id
                                                        : video2.id.toString(),
                                                    video: widget.id == null
                                                        ? widget.video
                                                        : video2,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View Comments",
                                              style: GoogleFonts.ubuntu(
                                                  height: 1, color: primary),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Comments are disabled"),
                                          Icon(Icons.comment_outlined),
                                        ],
                                      ),
// <<<<<<< HEAD
//                         Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: Column(
//                             children: [
//                               TextButton(
//                                 onPressed: () {},
//                                 child: Text("Following"),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Divider(
//                       color: Colors.grey,
//                       height: 10,
//                     ),
//                     Container(
//                       //height: MediaQuery.of(context).size.height * 1 / 14,
//                       width: double.infinity,
//                       child: AdPost(),
//                       // child: Text(
//                       //   'Add banner comes here',
//                       //   style: TextStyle(color: Colors.white),
//                       // ),
//                       //color: Colors.black,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "${widget.id==null?widget.video.comments:video2.comments} Comments",
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Comments(
//                                           videoId: widget.id==null?widget.video.id:video2.id.toString(),
//                                         )),
//                               );
//                             },
//                             child: Text(
//                               "More",
//                               style: TextStyle(height: 1),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       // height: h / 2,
//                       child: Container(
//                         // height: h / 2,
//                         child: StreamBuilder(
//                           stream: CommentServices()
//                               .getOneVideoComments(widget.id==null?widget.video.id:video2.id.toString()),
//                           builder: (BuildContext context,
//                               AsyncSnapshot<QuerySnapshot> snapshot) {
//                             if (snapshot.hasData) {
//                               return ListView(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 children: snapshot.data.docs.map((doc) {
//                                   CommentModel comment =
//                                       CommentModel.fromMap(doc.data());
//                                   List<QueryDocumentSnapshot<Object>>
//                                       replyComments = snapshot.data.docs
//                                           .where((o) =>
//                                               o['commentId'] ==
//                                               'reply-' + comment.commentId)
//                                           .toList();
//                                   return Comment(
//                                       comment: comment, replies: replyComments);
//                                 }).toList(),
//                               );
//                             } else {
//                               return Container(
//                                 child: Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               );
//                             }
//                           },
//                           // future: VideoServices.getAllVideos(),
//                         ),
//                       ),
//                     ),
//                   ],
// =======
                              ),
                              // Container(
                              //   padding: const EdgeInsets.all(8.0),
                              //   // height: h / 2,
                              //   child: Container(
                              //     // height: h / 2,
                              //     child: StreamBuilder(
                              //       stream: CommentServices().getOneVideoComments(
                              //         widget.id == null
                              //             ? widget.video.id
                              //             : video2.id.toString(),
                              //       ),
                              //       builder: (BuildContext context,
                              //           AsyncSnapshot<QuerySnapshot> snapshot) {
                              //         if (snapshot.hasData) {
                              //           return ListView(
                              //             physics: NeverScrollableScrollPhysics(),
                              //             shrinkWrap: true,
                              //             children: snapshot.data.docs.map((doc) {
                              //               CommentModel comment =
                              //                   CommentModel.fromMap(doc.data());
                              //               List<QueryDocumentSnapshot<Object>>
                              //                   replyComments = snapshot.data.docs
                              //                       .where((o) =>
                              //                           o['commentId'] ==
                              //                           'reply-' + comment.commentId)
                              //                       .toList();
                              //               return Comment(
                              //                   comment: comment,
                              //                   replies: replyComments);
                              //             }).toList(),
                              //           );
                              //         } else {
                              //           return Container(
                              //             child: Center(
                              //               child: CircularProgressIndicator(),
                              //             ),
                              //           );
                              //         }
                              //       },
                              //       // future: VideoServices.getAllVideos(),
                              //     ),
                              //   ),
                              // ),
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
