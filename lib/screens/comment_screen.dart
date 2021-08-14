import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/video.dart';
import 'package:millions/services/commentServices.dart';
import 'package:millions/services/userService.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/model/comment_model.dart';

class Comments extends StatefulWidget {
  final String videoId;
  final Video video;

  const Comments({Key key, this.videoId, this.video}) : super(key: key);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  // void like(int id) {
  //   setState(() {
  //     print(id);
  //   });
  // }

  Future<String> profilePic;
  bool isOwner = true;
  int count = 0;
  String commentId = FirebaseAuth.instance.currentUser.uid +
      '-' +
      DateTime.now().millisecondsSinceEpoch.toString();
  String uniqueId = FirebaseAuth.instance.currentUser.uid +
      '-' +
      DateTime.now().millisecondsSinceEpoch.toString();

  List<DocumentSnapshot> _comments = [];
  bool _loadingComments = true,
      _gettingMoreComments = false,
      _moreCommentsAvailable = true;
  int _perPage = 10;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();

  _getComments() async {
    Query q = FirebaseFirestore.instance
        .collection("comments")
        .where('videoId', isEqualTo: widget.videoId)
        .orderBy("date", descending: true)
        .limit(_perPage);

    setState(() {
      _loadingComments = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _comments = querySnapshot.docs;
    _lastDocument = querySnapshot.docs.length.toInt() == 0
        ? null
        : querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      _loadingComments = false;
    });
  }

  _getMoreComments() async {
    if (!_moreCommentsAvailable) {
      print("No more products");
      return;
    }
    if (_gettingMoreComments) {
      return;
    }

    _gettingMoreComments = true;
    Query q = FirebaseFirestore.instance
        .collection("comments")
        .orderBy("date", descending: true)
        .limit(_perPage)
        .startAfter([_lastDocument['id']]);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < _perPage) {
      _moreCommentsAvailable = false;
    }
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _comments.addAll(querySnapshot.docs);

    setState(() {
      _gettingMoreComments = false;
    });
  }

  @override
  void initState() {
    super.initState();

    // profilePic = UserServices().getUserDetails(altUserId);
    _getComments();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        _getMoreComments();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    TextEditingController getcomment = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                child: ClipRRect(
                  child: Image.network(
                    FirebaseAuth.instance.currentUser.photoURL,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(w * 0.1),
                ),
                //backgroundColor: Colors.black,
              ),
              // FutureBuilder(
              //   future: UserServices().getUserDetails(altUserId),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return CircleAvatar(
              //         child: ClipRRect(
              //           child: Image.network(
              //             snapshot.data.toString(),
              //             fit: BoxFit.cover,
              //           ),
              //           borderRadius: BorderRadius.circular(w * 0.1),
              //         ),
              //         //backgroundColor: Colors.black,
              //       );
              //     } else {
              //       return CircleAvatar(
              //         radius: w * 0.1,
              //         backgroundColor: Colors.black,
              //       );
              //     }
              //   },
              // ),
              title: TextFormField(
                controller: getcomment,
                cursorColor: primary,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    child: Icon(
                      Icons.send,
                      color: primary,
                    ),
                    onTap: () {
                      if (getcomment.text.length > 0) {
                        // print(getcomment.text);
                        setState(() {});
                        CommentServices().addVideoComment(
                            widget.video.channelId,
                            widget.video.channelName,
                            getcomment.text,
                            FirebaseAuth.instance.currentUser.uid +
                                '-' +
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            FirebaseAuth.instance.currentUser.uid ==
                                    widget.video.channelId
                                ? true
                                : false,
                            "watch/" + widget.video.id,
                            FirebaseAuth.instance.currentUser.displayName,
                            FirebaseAuth.instance.currentUser.photoURL,
                            "main-comment",
                            uniqueId,
                            "video",
                            FirebaseAuth.instance.currentUser.uid,
                            widget.video.id,
                            widget.video.title);
                      }
                      getcomment.clear();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Comments(
                              video: widget.video,
                              videoId: widget.video.id,
                            ),
                          ));
                      setState(() {
                        count++;
                      });
                    },
                  ),
                  // labelText: 'Add a comment',
                  hintText: 'Add a comment',
                  labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              child: _loadingComments
                  ? Center(
                      child: Container(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    ))
                  : _comments.length == 0
                      ? Center(
                          child: Container(
                          child: Text('No comments!',
                              style: GoogleFonts.ubuntu(fontSize: 15)),
                        ))
                      : Column(
                          children: [
                            ListView.builder(
                                itemCount: _comments.length,
                                controller: _scrollController,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctx, int index) {
                                  CommentModel comment = CommentModel.fromMap(
                                      _comments[index].data());
                                  List<QueryDocumentSnapshot<Object>>
                                      replyComments = _comments
                                          .where((o) =>
                                              o['commentId'] ==
                                              'reply-' + comment.commentId)
                                          .toList();
                                  if (comment.commentId
                                      .contains(new RegExp(r'reply'))) {
                                    print(123);
                                    return Container();
                                  } else {
                                    return Comment(
                                        video: widget.video,
                                        comment: comment,
                                        replies: replyComments);
                                  }
                                })
                          ],
                        ),
              // child: StreamBuilder(
              //   stream: CommentServices()
              //       .getVideoComments(widget.videoId.toString()),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.hasData) {
              //       return ListView(
              //         physics: NeverScrollableScrollPhysics(),
              //         shrinkWrap: true,
              //         children: snapshot.data.docs.map((doc) {
              //           CommentModel comment = CommentModel.fromMap(doc.data());
              //           List<QueryDocumentSnapshot<Object>> replyComments =
              //               snapshot
              //                   .data.docs
              //                   .where((o) =>
              //                       o['commentId'] ==
              //                       'reply-' + comment.commentId)
              //                   .toList();
              //           if (comment.commentId.contains(new RegExp(r'reply'))) {
              //             print(123);
              //             return Container();
              //           } else {
              //             return Comment(
              //                 comment: comment, replies: replyComments);
              //           }
              //         }).toList(),
              //       );
              //     } else {
              //       return Container(
              //         child: Center(
              //           child: CircularProgressIndicator(),
              //         ),
              //       );
              //     }
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
