import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/services/commentServices.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/model/comment_model.dart';

class Comments extends StatefulWidget {
  final String videoId;

  const Comments({Key key, this.videoId}) : super(key: key);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  // void like(int id) {
  //   setState(() {
  //     print(id);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    TextEditingController getcomment = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Comments'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: ClipRRect(
                child: Image.network(
                  'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
                  width: w * 0.3,
                  height: w * 0.3,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(w * 0.1),
              ),
              // backgroundColor: Colors.black,
            ),
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
                      // setState(() {
                      // comments.add(
                      //   CommentModel(
                      //       comments,
                      //       'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
                      //       'Hrithwik',
                      //       getcomment.text,
                      //       'now',
                      //       '0 likes',
                      //       false),
                      // );
                      // print(comments);
                      // });
                      print("add commment");
                    }
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
            height: h / 1.3,
            child: StreamBuilder(
              stream: CommentServices()
                  .getVideoComments(widget.videoId.toString()),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data.docs[1]['comment']);
                  return ListView(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((doc) {
                      CommentModel comment =
                          CommentModel.fromMap(doc.data());
                      List<QueryDocumentSnapshot<Object>> replyComments =
                          snapshot.data.docs
                              .where((o) =>
                                  o['commentId'] ==
                                  'reply-' + comment.commentId)
                              .toList();
                      return Comment(
                        comment: comment,
                        replies: replyComments
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
            ),
          )
        ],
      ),
    );
  }
}
