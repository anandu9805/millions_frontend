import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/model/comment_model.dart';
import '../constants/colors.dart';

class Comment extends StatefulWidget {
  final CommentModel comment;

  const Comment({Key key, this.comment}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  void initState() {
    print(widget.comment.commentId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        Row(
          children: [
            IconButton(
              onPressed: () {
                print("pressed like");
                print(widget.comment.userId);
              },
              iconSize: 15,
              splashRadius: 10,
              splashColor: primary,
              icon: true
                  ? Icon(
                      Icons.thumb_up,
                      color: primary,
                    )
                  // ignore: dead_code
                  : Icon(
                      Icons.thumb_up_alt_outlined,
                    ),
            ),
            Text(
              "${widget.comment.likes}",
            ),
            IconButton(
              onPressed: () {
                print("pressed like");
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
        Divider(height: 25,),
      ],
    );
  }
}
