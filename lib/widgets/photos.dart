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
        'The rumors and leaks were indeed true. Microsoft just officially announced #Windows11 at its big June 24 event as the next generation of Windows. Hitting general availability this holiday season, this is following up on over 5 years of updates to Windows 10. ',
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
    var w = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white30,
      padding: EdgeInsets.all(4),
      child: Card(
        margin: EdgeInsets.all(1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(w * 0.1),
                          child: CircleAvatar(
                            child: Image.network(
                              'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
                              width: w * 0.3,
                              height: w * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width:5),

                    Column(
                      children: [
                        Text(
                          content[Photos.index].userName,
                          style: GoogleFonts.ubuntu(
                              color: Colors.grey,
                              fontSize: 15,
                              height: 1.2,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(child: Image.network(content[Photos.index].url)),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: w * 0.6,
                          child: Text(
                            content[Photos.index].tagLine,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          content[Photos.index].timeSinceUpload + ' Ago',
                          style: GoogleFonts.ubuntu(
                              color: Colors.grey, fontSize: 15, height: 1.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  // SizedBox(width: 16),
                  Icon(Icons.favorite_border),
                  SizedBox(width: 16),
                  Icon(Icons.share_outlined),
                  SizedBox(width: 16),
                  Transform.rotate(
                      angle: 5.5, child: Icon(Icons.send_outlined)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}