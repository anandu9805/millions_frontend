import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/comment_model.dart';
import 'package:millions/services/commentServices.dart';
import '../constants/colors.dart';

class Comment extends StatefulWidget {
  final CommentModel comment;
  final List<QueryDocumentSnapshot<Object>> replies;

  const Comment({Key key, this.comment, this.replies}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  void initState() {
    print(widget.comment.commentId);
    print(widget.replies.length + 10);
    super.initState();
  }

  bool liked;
  @override
  void dispose() {
    String likeId = altUserId + '_' + widget.comment.commentId;
    print(likeId);
    Future<DocumentSnapshot> likedData =
        CommentServices().commentLikeChecker(likeId);
    likedData.then((value) {
      setState(() {
        liked = value.get('liked') || false;
        liked = liked ?? false;
      });
    });
    super.dispose();
  }

  bool isOwner = true;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // SizedBox(height: 10,)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 20,
              child: ClipRRect(
                child: Image.network(
                  widget.comment.profilePic == null
                      ? 'https://img-premium.flaticon.com/png/512/552/premium/552909.png?token=exp=1625761770~hmac=50547f60af312c1b16263272abb7c4ba'
                      : widget.comment.profilePic,
                  width: w * 0.3,
                  height: w * 0.3,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(w * 0.1),
              ),
              // backgroundColor: Colors.black,
            ),
            SizedBox(width: 10),
            Flexible(
              child: RichText(
                text: TextSpan(
                  text: "${widget.comment.name}   ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: widget.comment.comment,
                      style: GoogleFonts.ubuntu(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Icon(Icons.favorite_border)
          ],
        ),
        // Text("Replies"),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
          itemCount: widget.replies.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(left: w * 0.2, bottom: 10),
              width: w * 0.7,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 15,
                    child: ClipRRect(
                      child: Image.network(
                        widget.replies[index]['profilePic'] == null
                            ? 'https://img-premium.flaticon.com/png/512/552/premium/552909.png?token=exp=1625761770~hmac=50547f60af312c1b16263272abb7c4ba'
                            : widget.replies[index]['profilePic'],
                        width: w * 0.3,
                        height: w * 0.3,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(w * 0.1),
                    ),
                    // backgroundColor: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: "${widget.replies[index]['name']}   ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(
                            text: widget.replies[index]['comment'],
                            style: GoogleFonts.ubuntu(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Icon(Icons.favorite_border)
                ],
              ),
            );
          },
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                print("pressed like");
                CommentServices().likeComment(
                    widget.comment.channel,
                    widget.comment.comment,
                    widget.comment.commentId,
                    widget.comment.userId,
                    altUserId,
                    isOwner,
                    "user 1",
                    altProfilePic,
                    widget.comment.type,
                    widget.comment.videoId,
                    widget.comment.videoTitle);
                print(widget.comment.userId);
              },
              iconSize: 15,
              splashRadius: 10,
              splashColor: primary,
              icon: liked == true
                  ? Icon(
                      Icons.thumb_up,
                      color: primary,
                    )
                  : Icon(
                      Icons.thumb_up_alt_outlined,
                    ),
            ),
            FutureBuilder(
                future: CommentServices()
                    .getCommentLikeCount(widget.comment.commentId),
                builder: (context, snapshot) {
                  print(snapshot.data);
                  return Text(
                    "${snapshot.data}",
                    style: TextStyle(height: 0.3, fontSize: 10),
                  );
                }),
            IconButton(
              onPressed: () {
                print("pressed like");
                CommentServices().dislikeComment(
                    widget.comment.channel,
                    widget.comment.comment,
                    widget.comment.commentId,
                    widget.comment.userId,
                    altUserId,
                    isOwner,
                    "user 1",
                    altProfilePic,
                    widget.comment.type,
                    widget.comment.videoId,
                    widget.comment.videoTitle);
                print(widget.comment.userId);
              },
              iconSize: 15,
              splashRadius: 10,
              splashColor: primary,
              icon: false
                  // ignore: dead_code
                  ? Icon(
                      Icons.thumb_down,
                      color: primary,
                    )
                  // ignore: dead_code
                  : Icon(
                      Icons.thumb_down_alt_outlined,
                    ),
            ),
            Text(
              "${widget.comment.dislikes}",
            ),
          ],
        ),
        Divider(
          height: 25,
        ),
      ],
    );
  }
}
