import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'hello',
            style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'സ്വന്തമായി കേറി പോകാൻ പറ്റുന്ന plane ഒക്കെ ഉണ്ടാക്കാൻ എല്ലാരും പടിക്കേണ്ടി വരും. മറ്റേ ചെങ്ങായി എപ്പോഴാ നാട് വിട്ടു പോകാൻ പറയുന്നത് എന്നറിയില്ല. ',
              style: GoogleFonts.ubuntu(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
