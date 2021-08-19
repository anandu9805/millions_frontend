import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/services/commentServices.dart';
import 'package:millions/services/userService.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/model/comment_model.dart';

class PostComments extends StatefulWidget {
  final String commentId;
  final PostDetail post;

  const PostComments({Key key, this.commentId, this.post}) : super(key: key);
  @override
  _PostCommentsState createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  // void like(int id) {
  //   setState(() {
  //     print(id);
  //   });
  // }
  Future<String> profilePic;
  bool isOwner;
  String commentId =
      altUserId + '-' + DateTime.now().millisecondsSinceEpoch.toString();
  String uniqueId =
      altUserId + '-' + DateTime.now().millisecondsSinceEpoch.toString();
  @override
  void initState() {
    // profilePic = UserServices().getUserDetails(altUserId);
    super.initState();
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
              //  FutureBuilder(
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
                        CommentServices().addVideoComment(
                            widget.post.channelId,
                            widget.post.channelName,
                            getcomment.text,
                            altUserId +
                                '-' +
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            //TODO - is verified
                            false,
                            widget.post.channelId ==
                                FirebaseAuth.instance.currentUser.uid,
                            "posts/" + widget.post.id,
                            FirebaseAuth.instance.currentUser.displayName,
                            FirebaseAuth.instance.currentUser.photoURL,
                            "main-comment",
                            uniqueId,
                            "posts",
                            FirebaseAuth.instance.currentUser.uid,
                            widget.post.id,
                            widget.post.title);
                      }
                      getcomment.clear();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostComments(
                              post: widget.post,
                              commentId: widget.commentId,
                            ),
                          ));
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
              child: StreamBuilder(
                stream: CommentServices()
                    .getPostComments(widget.post.id.toString()),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.size);
                    print(widget.post.id);
                    return ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((doc) {
                        CommentModel comment = CommentModel.fromMap(doc.data());
                        List<QueryDocumentSnapshot<Object>> replyComments =
                            snapshot
                                .data.docs
                                .where((o) =>
                                    o['commentId'] ==
                                    'reply-' + comment.commentId)
                                .toList();
                        if (comment.commentId.contains(new RegExp(r'reply'))) {
                          print(123);
                          return Container();
                        } else {
                          return Comment(
                              comment: comment, replies: replyComments);
                        }
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
