import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class Comment extends StatelessWidget {
  Function Like;
  int id;
  String url;
  String name;
  String comment_text;
  String time;
  String likes_number;
  bool liked;

  Comment(Function Like, int id, String url, String name, String comment_text,
      String time, String likes_number, bool liked) {
    this.Like = Like;
    this.id = id;
    this.url = url;
    this.name = name;
    this.comment_text = comment_text;
    this.time = time;
    this.likes_number = likes_number;
    this.liked = liked;
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
            children: [
              SizedBox(width: 10,),
          CircleAvatar(
            radius: 15,
            child: ClipRRect(
              child: Image.network(
                this.url,
                width: w * 0.3,
                height: w * 0.3,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(w * 0.1),
            ),
            // backgroundColor: Colors.black,
          ),
SizedBox(width: 15,),
          Text(
            this.name,
            style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
          ),

          SizedBox(width: 10),
          Expanded(
            child: Text(
              this.comment_text,
              style: GoogleFonts.ubuntu(fontSize: 12),
            ),
          ),
          // Icon(Icons.favorite_border)
          IconButton(
              onPressed: () {
                print("pressed like");
                print(this.id);
                this.Like(this.id);
              },
              icon: this.liked
                  ? Icon(
                      Icons.favorite,
                      color: primary,
                    )
                  : Icon(
                      Icons.favorite_border_outlined,
                    )),
        ]),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            SizedBox(
              width:60,
            ),
            Text(this.time),
            SizedBox(
              width: 10,
            ),
            Text(this.likes_number)
          ],
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
