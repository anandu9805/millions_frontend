import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/view_video.dart';
//import 'package:millions/screens/view_video.dart';
import '../model/content.dart';
import '../screens/comment_screen.dart';
class Photos extends StatefulWidget {
  int index;
  Photos(int index) {
    this.index = index;
  }

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  Color favIconColor = Colors.black;

  IconData like = Icons.favorite_border;

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
                    SizedBox(width: 5),
                    Column(
                      children: [
                        Text(
                          content[this.widget.index].userName,
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
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

              InkWell(onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>ViewVideo()),
                );
              },child: Container(child: Image.network(content[this.widget.index].url,fit:BoxFit.fill ,))),

              SizedBox(height: 10),
              Row(
                children: [
                  // SizedBox(width: 16),
                  InkWell(
                    child: Icon(
                      like,
                      color: favIconColor,
                    ),
                    onDoubleTap: () {
                      setState(() {
                        if (favIconColor == Colors.black) {
                          like= Icons.favorite;
                          favIconColor = primary;
                        } else {
                          like=Icons.favorite_outline;
                          favIconColor = Colors.black;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.share_outlined),
                  SizedBox(width: 16),
                  Transform.rotate(
                      angle: 5.5, child: Icon(Icons.send_outlined)),
                  FlatButton(onPressed:(){          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Comments()),
                  );

                  }, child:Text('View comments', style: GoogleFonts.ubuntu(),),)
                ],
              ),
              SizedBox(height: 10),





            ],
          ),
        ),
      ),
    );
  }
}
