import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/comment_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/comment_screen.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/services/commentServices.dart';
import 'package:millions/services/likeServices.dart';
import 'package:millions/services/report-services.dart';
import 'package:millions/services/userService.dart';
import 'package:millions/services/video-services.dart';
import 'package:millions/widgets/ads.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/widgets/playVideo.dart';
import '../services/dynamiclinkservice.dart';
import 'package:share_plus/share_plus.dart';

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
  SingingCharacter _character = SingingCharacter.lafayette;
  Video video2 = null;
  FlickManager flickManager;
  bool playState = false;
  bool liked = false;
  String likeId;
  String userId = "XIi08ww5Fmgkv7FXOSTkOcmVh2C3";
  var _isLoading = true;

  // Default Radio Button Selected Item.
  String radioItemHolder = 'One';

  // Group Value for Radio Button.
  int id = 1;
  List<String> reasons = [
    "Spam Content",
    "Explisit or Sexual Content",
    "Child Abuse",
    "Against law",
    "Harassment or bullying"
  ];

  List<ReasonList> nList = [
    ReasonList(
      index: 1,
      reason: "Spam Content",
    ),
    ReasonList(
      index: 2,
      reason: "Explisit or Sexual Content",
    ),
    ReasonList(
      index: 3,
      reason: "Child Abuse",
    ),
    ReasonList(
      index: 4,
      reason: "Against law",
    ),
    ReasonList(
      index: 5,
      reason: "Harassment or bullying",
    ),
  ];
  String dynamic_link;
  List parameters = ['videos'];
  String selectedReason;
  bool isSelected = false;
  int value;
  bool flag = true;
  int selectedRadio = -1;

  changeValue(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

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

  reportPopUp(h) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding:
                EdgeInsets.symmetric(vertical: h * 0.15, horizontal: 20),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "Report",
                  style: TextStyle(color: primary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: primary),
                ),
              ),
            ],
            title: Text("Report video"),
            content: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                          "If you belive this content is against our guidelines, kindly report. Your identity will not be revealed"),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    RadioListTile<SingingCharacter>(
                      title: const Text('Lafayette'),
                      value: SingingCharacter.lafayette,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                    RadioListTile<SingingCharacter>(
                      title: const Text('Thomas Jefferson'),
                      value: SingingCharacter.jefferson,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
    ReportServices().reportVideo(widget.video, "Against law");
  }

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: IconButton(
              icon: Icon(
                Icons.search_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                //go to search screen
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
            child: InkWell(
              child: CircleAvatar(
                backgroundColor: Colors.black,
              ),
              onTap: () {},
            ),
          )
        ],
      ),
      body: (_isLoading == false || widget.id == null)
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Expanded(
                  child: Column(
                    children: [
                      PlayVideo(
                        videoSrc: widget.id == null
                            ? widget.video.videoSrc
                            : video2.videoSrc,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                widget.id == null
                                    ? widget.video.title
                                    : video2.title,
                                maxLines: flag ? 2 : 10,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
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
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${widget.id == null ? widget.video.views : video2.views} views  | ${widget.id == null ? timeAgo(DateTime.fromMicrosecondsSinceEpoch(widget.video.date.microsecondsSinceEpoch)) : timeAgo(DateTime.fromMicrosecondsSinceEpoch(video2.date.microsecondsSinceEpoch))}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      style:
                                          TextStyle(height: 0.3, fontSize: 10),
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
                                  parameters = ['videos'];
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
                                style: TextStyle(height: 0.3, fontSize: 10),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  reportPopUp(h);
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
                                style: TextStyle(height: 0.3, fontSize: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Page8(
                                                  widget.id == null
                                                      ? widget.video.channelId
                                                      : video2.channelId)),
                                        );
                                      },
                                      child: FutureBuilder(
                                          future: UserServices().getUserDetails(
                                              widget.id == null
                                                  ? widget.video.channelId
                                                  : video2.channelId),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return CircleAvatar(
                                                child: ClipRRect(
                                                  child: Image.network(
                                                    snapshot.data.toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          w * 0.1),
                                                ),
                                                //backgroundColor: Colors.black,
                                              );
                                            } else {
                                              return CircleAvatar(
                                                // radius: w * 0.05,
                                                backgroundColor: Colors.black,
                                              );
                                            }
                                          }),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        "${widget.id == null ? widget.video.channelName : video2.channelName}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text("Following"),
                                )
                              ],
                            ),
                          ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.id == null ? widget.video.comments : video2.comments} Comments",
                            ),
                            TextButton(
                              onPressed: () {
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
                              },
                              child: Text(
                                "More",
                                style: TextStyle(height: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        // height: h / 2,
                        child: Container(
                          // height: h / 2,
                          child: StreamBuilder(
                            stream: CommentServices().getOneVideoComments(
                              widget.id == null
                                  ? widget.video.id
                                  : video2.id.toString(),
                            ),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: snapshot.data.docs.map((doc) {
                                    CommentModel comment =
                                        CommentModel.fromMap(doc.data());
                                    List<QueryDocumentSnapshot<Object>>
                                        replyComments = snapshot.data.docs
                                            .where((o) =>
                                                o['commentId'] ==
                                                'reply-' + comment.commentId)
                                            .toList();
                                    return Comment(
                                        comment: comment,
                                        replies: replyComments);
                                  }).toList(),
                                );
                              } else {
                                return Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                            // future: VideoServices.getAllVideos(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
