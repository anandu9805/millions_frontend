import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_time_ago/flutter_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/post_coments.dart';
import 'package:millions/services/likeServices.dart';
import 'package:millions/widgets/popUpMenu.dart';
import 'package:millions/screens/comment_screen.dart';
import 'package:millions/widgets/reportPost.dart';
import 'package:millions/widgets/skeletol_loader.dart';
import 'package:numeral/numeral.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/colors.dart';
import '../services/dynamiclinkservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  //String altUserId = "4C4iLByizTPLBBlP4rssrwGTISb2";
  String likeId;

  String dynamic_link;
  List parameters = ['posts'];
  @override
  void initState() {
    super.initState();
    likeId = altUserId + '_' + widget.photo.id;
    Future<DocumentSnapshot> likedData = LikeServices().postLikeChecker(likeId);
    likedData.then((value) {
      setState(() {
        liked = value.get('liked') || false;
        liked = liked ?? false;
      });
    });
    // Future<DocumentSnapshot> likeData = LikeServices().postLikeChecker(likeId);

    // likeData.then((value) {
    //   if (value.get('liked') == null) {
    //     setState(() {
    //       liked = false;
    //     });
    //   } else {
    //     setState(() {
    //       liked = value.get('liked');
    //     });
    //   }
    // });
    //print(liked);
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
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Page8(widget.photo.channelId)),
                              );
                            },
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
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.57),

                              // alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(right: 1.0),
                              child: Text(
                                widget.photo.channelName,

                                //content[this.widget.index].userName,
                                style: GoogleFonts.ubuntu(
                                    color: Colors.black,
                                    fontSize: 15,
                                    height: 1.2,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.photo.isVerified)
                              Icon(
                                Icons.verified,
                                size: 20,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    // height: 200.0,

                    child: ExpandableText(
                      widget.photo.description,
                      expandText: 'show more',
                      collapseText: 'show less',
                      maxLines: 5,
                      style: GoogleFonts.ubuntu(),
                      linkColor: Colors.blue,
                    ),

                    // Text(
                    //   widget.photo.description,
                    //   textAlign: TextAlign.left,

                    //   //content[this.widget.index].tagLine,
                    //   style: GoogleFonts.ubuntu(),
                    // ),
                  )
                ],
              ),

              SizedBox(height: 5),

              InkWell(
                  onDoubleTap: () {
                    if (liked == true) {
                      //print(0);
                      setState(() {
                        liked = !liked;
                      });
                      LikeServices().unLikePost(
                          widget.photo.id, widget.photo.channelId, altUserId);
                    } else {
                      //print(1);

                      setState(() {
                        liked = !liked;
                      });
                      LikeServices().likePost(
                          widget.photo.id, widget.photo.channelId, altUserId);
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ViewVideo()),
                    // );
                  },
                  child: Container(
                    // height: 400,
                    // color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: ClipRect(
                          // clipBehavior: Clip.hardEdge,
                          child: Container(
                            child: Align(
                              alignment: Alignment(-0.5, -0.2),
                              widthFactor: 1,
                              heightFactor: 1,
                              child: InteractiveViewer(
                                //boundaryMargin: const EdgeInsets.all(20.0),
                                //minScale: 0.1,
                                maxScale: 10,
                                child: CachedNetworkImage(
                                  placeholder: (context, thumbnailUrl) =>
                                      SkeletonContainer.square(
                                    width: MediaQuery.of(context).size.width,
                                    height: 500,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 1,
                                    child: Text("hi"),
                                  ),
                                  imageUrl: widget.photo?.photoSrc == null
                                      ? altChannelArt
                                      : widget.photo?.photoSrc,
                                ),
                              ),
                            ),
                          ),
                        )),
                  )
                  // PinchZoomImage(
                  //image:
                  //     Image.network(
                  //   widget.photo.photoSrc == null
                  //       ? altChannelArt
                  //       : widget.photo.photoSrc,
                  //   loadingBuilder: (BuildContext context, Widget child,
                  //       ImageChunkEvent loadingProgress) {
                  //     if (loadingProgress == null) return child;
                  //     return Center(
                  //       child: CircularProgressIndicator(
                  //         color: primary,
                  //         value: loadingProgress.expectedTotalBytes != null
                  //             ? loadingProgress.cumulativeBytesLoaded /
                  //                 loadingProgress.expectedTotalBytes
                  //             : null,
                  //       ),
                  //     );
                  //   },

                  //   //content[this.widget.index].url,
                  //   // fit: BoxFit.fill,
                  // ),
                  // //  zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                  //hideStatusBarWhileZooming: true,
                  //  ),
                  ),
              SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${Numeral(widget.photo?.likes).value()} Likes • ${Numeral(widget.photo?.comments).value()} Comments • ${FlutterTimeAgo.parse(widget.photo?.date.toDate(), lang: 'en')}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.ubuntu(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: FutureBuilder(
                      future: LikeServices().postLikeChecker(likeId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Icon(Icons.favorite);
                        } else {
                          if (snapshot.data == null) {
                            //print(10);
                          }
                          // setState(() {
                          //   liked = snapshot.data['liked'] ?? false;
                          // });
                          // print(snapshot.data['liked']);
                          return liked == true
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      liked = !liked;
                                    });
                                    LikeServices().unLikePost(widget.photo.id,
                                        widget.photo.channelId, altUserId);
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: primary,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      liked = !liked;
                                    });
                                    LikeServices().likePost(widget.photo.id,
                                        widget.photo.channelId, altUserId);
                                  },
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: favIconColor,
                                  ),
                                );
                        }
                      },
                    ),

                    // child: GestureDetector(
                    //   child: Icon(
                    //     like,
                    //     color: favIconColor,
                    //   ),
                    //   onTap: () {
                    //     if (liked == true) {
                    //       setState(() {
                    //         liked = !liked;
                    //         like = Icons.favorite;
                    //         favIconColor = primary;
                    //       });
                    // LikeServices().likePost(widget.photo.id,
                    //     currentuserid, currentuserid);
                    //     } else {
                    //       setState(() {
                    //         liked = !liked;
                    //         like = Icons.favorite_outline;
                    //         favIconColor = Colors.black;
                    //       });
                    // LikeServices().unLikePost(widget.photo.id,
                    //     currentuserid, currentuserid);
                    //     }
                    //   },
                    // ),
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
                  IconButton(
                    icon: Icon(Icons.comment_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostComments(
                                commentId: widget.photo.id,
                                post: widget.photo)),
                      );
                    },
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: Icon(Icons.flag_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportPost(
                            post: widget.photo,
                          ),
                        ),
                      );
                    },
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => PostComments(
                  //               commentId: widget.photo.id,
                  //               post: widget.photo)),
                  //     );
                  //   },
                  //   child: Text(
                  //     'View comments',
                  //     style: GoogleFonts.ubuntu(color: Colors.black),
                  //   ),
                  // ),
                  widget.photo.channelId == altUserId
                      ? PopUpMenuIcon("posts", widget.photo.id)
                      : Row()
                ],
              ),
              SizedBox(height: 10),
              // Row(
              //   children: [
              //     Text(widget.photo.channelName,
              //         //content[this.widget.index].userName,
              //         style: GoogleFonts.ubuntu(fontWeight: FontWeight.w600)),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Expanded(
              //         child: Text(
              //       widget.photo.description,
              //       //widget.photo.title,

              //       //content[this.widget.index].tagLine,
              //       style: GoogleFonts.ubuntu(),
              //     )),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
