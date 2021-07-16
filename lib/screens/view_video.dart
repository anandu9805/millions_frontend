import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:millions/model/comment_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/comment_screen.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/services/commentServices.dart';
import 'package:millions/widgets/ads.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/widgets/playVideo.dart';

class ViewVideo extends StatefulWidget {
  final Video video;

  const ViewVideo({Key key, this.video}) : super(key: key);

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  FlickManager flickManager;
  bool playState = false;

  @override
  void initState() {
    super.initState();
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
                      IconButton(
                        onPressed:
                            () {}, //---------------------------------------------------
                        icon: Icon(Icons.thumb_up),
                      ),
                      Text(
                        "${widget.video.likes}",
                        style: TextStyle(height: 0.3, fontSize: 10),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.thumb_down),
                      ),
                      Text(
                        "${widget.video.disLikes}",
                        style: TextStyle(height: 0.3, fontSize: 10),
                      )
                    ],
                  ),
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
                          onPressed: () {}, icon: Icon(Icons.bookmark_add)),
                      Text(
                        "Save",
                        style: TextStyle(height: 0.3, fontSize: 10),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.flag)),
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
