import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:millions/model/comment_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/comment_screen.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/services/commentServices.dart';
import 'package:millions/services/likeServices.dart';
import 'package:millions/services/report-services.dart';
import 'package:millions/widgets/ads.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/widgets/playVideo.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/colors.dart';

import '../services/dynamiclinkservice.dart';

class ReasonList {
  String reason;
  int index;

  ReasonList({this.reason, this.index});
}

class ViewVideo extends StatefulWidget {
  final Video video;
  final String id;

  const ViewVideo({Key key,this.video, this.id}) : super(key: key);

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  Video video2=null;
  FlickManager flickManager;
  bool playState = false;
  bool liked = false;
  String likeId;
  String userId = "XIi08ww5Fmgkv7FXOSTkOcmVh2C3";
  var _isLoading =true;



  // Default Radio Button Selected Item.
  String radioItemHolder = 'One';

  // Group Value for Radio Button.
  int id = 1;

  List<ReasonList> nList = [
    ReasonList(
      index: 1,
      reason: "One",
    ),
    ReasonList(
      index: 2,
      reason: "Two",
    ),
    ReasonList(
      index: 3,
      reason: "Three",
    ),
    ReasonList(
      index: 4,
      reason: "Four",
    ),
    ReasonList(
      index: 5,
      reason: "Five",
    ),
  ];
  String dynamic_link;
  List parameters = ['watch'];

  @override
  void initState() {
    if (widget.id != null && widget.video == null) {
      //_isLoading=true;
      _getVideoFromId(); //to get the video from the id passesd through the dynamic link
    }
    else {
      likeId =
      widget.id == null ? userId + '_' + widget.video.id : userId + '_' +
          video2.id;
      Future<DocumentSnapshot> likedData = LikeServices().likeChecker(likeId);
      likedData.then((value) {
        setState(() {
          liked = value.get('liked') || false;
          liked = liked ?? false;
        });
      });
      print(liked);
      print("liked");
    }
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    return Scaffold(
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
                }),
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
      body: (_isLoading == false||widget.id==null)
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    PlayVideo(
                      videoSrc:
                        widget.id==null?widget.video.videoSrc:video2.videoSrc,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.id==null?widget.video.title:video2.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "${ widget.id==null?widget.video.views:video2.views} views  |  12 Minutes Ago",
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
                                          widget.id==null?widget.video.id:video2.id, userId, userId);
                                    }, //---------------------------------------------------
                                    icon: Icon(
                                      Icons.thumb_up,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      // setState(() {
                                      //   liked = !liked;
                                      // });
                                      //amjad change
                                      // LikeServices()
                                      //     .likeVideo( widget.id==null?widget.video.id:video2.id, userId, userId);
                                    }, //----------------------
                                    icon: Icon(
                                      Icons.thumb_up_alt_outlined,
                                    ),
                                  ),
                            Text(
                              "${ widget.id==null?widget.video.likes:video2.likes}",
                              style: TextStyle(height: 0.3, fontSize: 10),
                            )
                          ],
                        ),
                        // Column(
                        //   children: [
                        //     IconButton(
                        //       onPressed: () {
                        //         LikeServices()
                        //             .unLikeVideo(widget.id==null?widget.video.id:video2.id, userId, userId);
                        //       },
                        //       icon: Icon(Icons.thumb_down),
                        //     ),
                        //     Text(
                         //      "${widget.id==null?widget.video.disLikes:video2.disLikes}",
                        //       style: TextStyle(height: 0.3, fontSize: 10),
                        //     )
                        //   ],
                        // ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                parameters = ['watch'];
                                parameters.add(widget.id==null?widget.video.id:video2.id,);
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
                                  // print(123);
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return Flexible(
                                  //         child: Container(
                                  //           height:
                                  //               MediaQuery.of(context).size.height *
                                  //                   0.6,
                                  //           child: SimpleDialog(
                                  //             children: [
                                  //               ListView.builder(
                                  //                 shrinkWrap: true,
                                  //                 itemBuilder: (BuildContext context,
                                  //                     int index) {
                                  //                   return Text(nList[index].reason);
                                  //                 },
                                  //                 itemCount: nList.length,
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     });
                                  //
                                  // ReportServices()
                                 //      .reportVideo(widget.id==null?widget.video:video2, "inappropriate");
                                },
                                icon: Icon(Icons.flag)),
                            Text(
                              "Report",
                              style: TextStyle(height: 0.3, fontSize: 10),
                            )
                          ],
                        )
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
                                            builder: (context) =>
                                                Page8(widget.id==null?widget.video.channelId:video2.channelId)),
                                      );
                                    },
                                    child: CircleAvatar(
                                      foregroundImage: NetworkImage(
                                          widget.id==null?widget.video.thumbnailUrl:video2.thumbnailUrl),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text("${widget.id==null?widget.video.channelName:video2.channelName}"),
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
                            "${widget.id==null?widget.video.comments:video2.comments} Comments",
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Comments(
                                          videoId: widget.id==null?widget.video.id:video2.id.toString(),
                                        )),
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
                          stream: CommentServices()
                              .getOneVideoComments(widget.id==null?widget.video.id:video2.id.toString()),
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
                                      comment: comment, replies: replyComments);
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
