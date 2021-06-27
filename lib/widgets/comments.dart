import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Comment extends StatefulWidget {
  static String text;

  Comment(String index) {
    Comment.text = index;
  }

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 15,
            child: ClipRRect(
              child: Image.network(
                'https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F20%2F2020%2F03%2Fana-dearmas-3.jpg',
                width: w * 0.3,
                height: w * 0.3,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(w * 0.1),
            ),
            // backgroundColor: Colors.black,
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ray@20',
                style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  Comment.text,
                  style: GoogleFonts.ubuntu(fontSize: 12),
                ),
              ),
              Icon(Icons.favorite_border)
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            SizedBox(
              width: w / 5.5,
            ),
            Text('2 hours'),
            SizedBox(
              width: 10,
            ),
            Text('30 likes')
          ],
        )
      ],
    );
  }
}
