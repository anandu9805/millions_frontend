import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/screens/view_video.dart';
import '../model/content.dart';

class Photos extends StatefulWidget {
  static int index;
  Photos(int index) {
    Photos.index = index;
  }

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  List<Content> content = [
    Content(
        'https://cdn.pixabay.com/photo/2014/02/27/16/10/tree-276014__340.jpg',
        'Wonders of nature!!!!',
        'Mkbhd',
        '10 minutes'),
    Content('https://cdn.explore-life.com/media/1401/conversions/facebook.jpg',
        'fly high', 'Ritz', '20minutes'),
    Content(
        'http://public.media.smithsonianmag.com/legacy_blog/crested-ibis-pic.jpg',
        'Mysterious Birds spoted!!!!!',
        'nature geek',
        '30minutes'),
    Content(
        'https://i.pinimg.com/originals/4c/bc/db/4cbcdb5688e4e95b866cc0c50125f13f.jpg',
        'The Future is Here',
        'Who',
        '40minutes'),
    Content(
        'https://images.indianexpress.com/2021/01/siraj-india-vs-australia.jpg',
        'India win!!!!',
        'sun',
        '45minutes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          Container(
            child: Image.network(content[Photos.index].url),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: ListTile(
              dense: true,
              title: Text(
                content[Photos.index].tagLine,
                style: GoogleFonts.ubuntu(
                    fontSize: 15, fontWeight: FontWeight.w500, height: 1),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: Text(
                  content[Photos.index].userName,
                  style: GoogleFonts.ubuntu(
                      color: Colors.grey,
                      fontSize: 15,
                      height: 0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  content[Photos.index].timeSinceUpload + ' Ago',
                  style: GoogleFonts.ubuntu(
                      color: Colors.grey, fontSize: 15, height: 0),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 16),
                Icon(Icons.favorite),
                SizedBox(width: 16),
                Icon(Icons.share),
                SizedBox(width: 16),
                Icon(Icons.send),
              ],
            ),
          )
        ],
      ),
    );
  }
}
