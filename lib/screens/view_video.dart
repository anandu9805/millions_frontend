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

class ReasonList {
  String reason;
  int index;
  ReasonList({this.reason, this.index});
}

class ViewVideo extends StatefulWidget {
  final Video video;

  const ViewVideo({Key key, this.video}) : super(key: key);

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  FlickManager flickManager;
  bool playState = false;
  bool liked= false;
  String likeId;
  String userId = "XIi08ww5Fmgkv7FXOSTkOcmVh2C3";

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

  @override
  void initState() {
    super.initState();
    likeId = userId + '_' + widget.video.id;
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

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              PlayVideo(
                videoSrc: widget.video.videoSrc,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.video.title,
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
                      "${widget.video.views} views  |  12 Minutes Ago",
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
                                    widget.video.id, userId, userId);
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
                                LikeServices()
                                    .likeVideo(widget.video.id, userId, userId);
                              }, //----------------------
                              icon: Icon(
                                Icons.thumb_up_alt_outlined,
                              ),
                            ),
                      Text(
                        "${widget.video.likes}",
                        style: TextStyle(height: 0.3, fontSize: 10),
                      )
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
                        onPressed: () {},
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
                            print(123);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Flexible(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: SimpleDialog(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Text(nList[index].reason);
                                            },
                                            itemCount: nList.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
                            ReportServices()
                                .reportVideo(widget.video, "inappropriate");
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Page8(widget.video.channelId)),
                                );
                              },
                              child: CircleAvatar(
                                foregroundImage:
                                    NetworkImage(widget.video.thumbnailUrl),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("${widget.video.channelName}"),
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
                      "${widget.video.comments} Comments",
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Comments(
                                    videoId: widget.video.id.toString(),
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
                        .getOneVideoComments(widget.video.id.toString()),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: snapshot.data.docs.map((doc) {
                            CommentModel comment =
                                CommentModel.fromMap(doc.data());
                            return Comment(
                              comment: comment,
                            );
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
    );
  }
}
