import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/services/likeServices.dart';
import 'package:millions/widgets/popUpMenu.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';
import 'package:millions/screens/comment_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/colors.dart';
import '../services/dynamiclinkservice.dart';

import '../services/dynamiclinkservice.dart';

//import 'package:millions/screens/view_video.dart';
//import '../model/content.dart';

class Photos extends StatefulWidget {
  //int index;
  PostDetail photo;

  Photos(PostDetail pic) {
    this.photo = pic;

  }

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  Color favIconColor = Colors.black;

  IconData like = Icons.favorite_border;
  bool liked = false;
  String currentuserid = "4C4iLByizTPLBBlP4rssrwGTISb2";
  String likeId;

  String dynamic_link;
  List parameters = ['posts'];
  @override
  void initState() {
    super.initState();
    likeId = currentuserid + '_' + widget.photo.id;
    Future<DocumentSnapshot> likeData = LikeServices().postLikeChecker(likeId);
    likeData.then((value) {
      setState(() {
        liked = value.get('liked') == true ? true : false;
      });
    });
    print(liked);
  }

  // List<Content> content = [
  //   Content(
  //       'https://cdn.pixabay.com/photo/2014/02/27/16/10/tree-276014__340.jpg',
  //       'The rumors and leaks were indeed true. Microsoft just officially announced it..',
  //       'Mkbhd',
  //       '10 minutes'),
  //   Content('https://cdn.explore-life.com/media/1401/conversions/facebook.jpg',
  //       'fly high', 'Ritz', '20minutes'),
  //   Content(
  //       'http://public.media.smithsonianmag.com/legacy_blog/crested-ibis-pic.jpg',
  //       'Mysterious Birds spoted!!!!!',
  //       'nature geek',
  //       '30minutes'),
  //   Content(
  //       'https://i.pinimg.com/originals/4c/bc/db/4cbcdb5688e4e95b866cc0c50125f13f.jpg',
  //       'The Future is Here',
  //       'Who',
  //       '40minutes'),
  //   Content(
  //       'https://images.indianexpress.com/2021/01/siraj-india-vs-australia.jpg',
  //       'India win!!!!',
  //       'sun',
  //       '45minutes'),
  // ];

  @override
  Widget build(BuildContext context) {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    var w = MediaQuery.of(context).size.width;
    TransformationController pinch = new TransformationController();

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
                              widget.photo.profilePic == null
                                  ? altProfilePic
                                  : widget.photo.profilePic,
                              //widget.photo.profilePic,
                              // 'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
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
                          widget.photo.channelName,
                          //content[this.widget.index].userName,
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
              InkWell(
                onDoubleTap: () {
                  if (liked == true) {
                    print(0);
                    setState(() {
                      like = Icons.favorite;
                      favIconColor = primary;
                      liked = !liked;
                    });
                    LikeServices().likePost(
                        widget.photo.id, currentuserid, currentuserid);
                  } else {
                    print(1);

                    setState(() {
                      liked = !liked;
                      like = Icons.favorite_outline;
                      favIconColor = Colors.black;
                    });

                    LikeServices().unLikePost(
                        widget.photo.id, currentuserid, currentuserid);
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ViewVideo()),
                  // );
                },
                child: PinchZoomImage(
                  image: ClipRRect(
                    child: Image.network(
                      widget.photo.photoSrc == null
                          ? altChannelArt
                          : widget.photo.photoSrc,

                      //content[this.widget.index].url,
                      // fit: BoxFit.fill,
                    ),
                  ),
                  zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                  //hideStatusBarWhileZooming: true,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: GestureDetector(
                          child: Icon(
                            like,
                            color: favIconColor,
                          ),
                          onTap: () {
                            if (liked == true) {
                              setState(() {
                                liked=!liked;
                                like = Icons.favorite;
                                favIconColor = primary;
                              });
                              LikeServices().likePost(
                                  widget.photo.id, currentuserid, currentuserid);
                            } else {
                              setState(() {
                                liked=!liked;
                                like = Icons.favorite_outline;
                                favIconColor = Colors.black;
                              });
                              LikeServices().unLikePost(
                                  widget.photo.id, currentuserid, currentuserid);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        onPressed: () async {
                          parameters = ['posts'];
                          parameters.add(widget.photo.id);
                          print(parameters);
                          await _dynamicLinkService
                              .createDynamicLink(parameters)
                              .then((value) {
                            dynamic_link = value;
                          });
                          //here------------- ------------------    ---------------- -- --- --- --    ----   ---- --- -- -- - - - - - -----
                          Share.share(dynamic_link);
                        },
                        icon: Icon(
                          Icons.share,
                        ),
                      ),
                      SizedBox(width: 16),
                      Transform.rotate(
                          angle: 5.5, child: Icon(Icons.send_outlined)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Comments()),
                          );
                        },
                        child: Text(
                          'View comments',
                          style: GoogleFonts.ubuntu(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  widget.photo.channelId == altUserId
                      ? PopUpMenuIcon("posts", widget.photo.id)
                      : Row()
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(widget.photo.channelName,
                      //content[this.widget.index].userName,
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    widget.photo.description,
                    //widget.photo.title,

                    //content[this.widget.index].tagLine,
                    style: GoogleFonts.ubuntu(),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
