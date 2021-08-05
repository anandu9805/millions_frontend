import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:millions/screens/edit30s.dart';
import 'package:millions/services/dynamiclinkservice.dart';
import 'package:millions/services/likeServices.dart';
import 'package:numeral/numeral.dart';
import 'package:share_plus/share_plus.dart';
import '../model/reels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';

import 'package:google_fonts/google_fonts.dart';

class ChannelShorts extends StatefulWidget {
  final String channelId;
  ChannelShorts(this.channelId);

  @override
  _ShortsState createState() => _ShortsState();
}

class _ShortsState extends State<ChannelShorts> {
  //the id of the logged in user
  // var currentuserid = "DEyDJLaskaSXV5kMBLXSGBBZC062";
  List following_details = [];

  void deletenow(String coll, String doc) async {
    await FirebaseFirestore.instance
        .collection(coll)
        .doc(doc)
        .delete()
        .whenComplete(() {
      _showToast(context, "30s deleted");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChannelShorts(widget.channelId)),
      );
    }).catchError(
            (error) => _showToast(context, "Failed to delete 30s: $error"));
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: primary,
        ),
      ),
    );
  }

  SwiperController _scrollController = SwiperController();
  bool liked = false;
  String likeId;
  var _perpage = 10;
  List<Reels> reels_objects = [];
  List<DocumentSnapshot> _reels_items = [];
  DocumentSnapshot _lastdocument;
  var _isLoading = true;
  int number_of_items, swiper_number_of_items;
  String dynamic_link;
  List parameters = ['30s'];

  @override
  void initState() {
    // GetCurrentUserDetails();
    _getReels();
    super.initState();
  }

  // Future<String> GetCurrentUserDetails() async {
  //   //get current user details here
  //   try {
  //     print(
  //         "hello---------------------------------------------------------------------------------------------");
  //     await FirebaseFirestore.instance
  //         .collection('channels')
  //         .doc(altUserId)
  //         .get()
  //         .then((value) => print(value));
  //   } catch (e) {
  //     return "Follow";
  //   }
  // }

  _getReels() async {
    Query q = FirebaseFirestore.instance
        .collection('reels')
        .where('channelId', isEqualTo: widget.channelId)
        .orderBy("date", descending: true)
        .limit(_perpage);
    QuerySnapshot querySnapshot = await q.get();
    _reels_items = querySnapshot.docs;
    _lastdocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      _isLoading = false;
    });
    print("_getReels");
    print("_reels_items");
    print(_reels_items);
    number_of_items = _reels_items.length - 1;
    swiper_number_of_items = _reels_items.length;
  }

  _getMoreReels() async {
    print(_lastdocument.data());
    print(_lastdocument.id);
    Query q = FirebaseFirestore.instance
        .collection('reels')
        .where('channelId', isEqualTo: widget.channelId)
        .orderBy("date")
        .startAfterDocument(_lastdocument);
    QuerySnapshot querySnapshot = await q.get();
    setState(() {
      swiper_number_of_items = _reels_items.length;
    });
    if (querySnapshot.docs.length == 0) {
      print("empty-------------------------------------------");
    } else {
      _lastdocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      _reels_items.addAll(querySnapshot.docs);
      print("_getMoreReels");
      print("_reels_items");
      print(_reels_items);
      number_of_items = _reels_items.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DynamicLinkService _dynamicLinkService = DynamicLinkService();
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading == false
          ? Swiper(
              onIndexChanged: (int index) {
                print(
                    "--------------------------------------------------------------------------------------------");
                print(index);
                if (number_of_items - index == 2) {
                  print(
                      "Now going to get more items---------------------------------------------------------------");
                  _getMoreReels();
                }
              },
              controller: _scrollController,
              containerWidth: MediaQuery.of(context).size.width,
              itemBuilder: (BuildContext context, int index) {
                return Stack(children: [
                  ContentScreen(
                      src: _reels_items[index]["videoSrc"],
                      cover: _reels_items[index]
                          ["thumbnail"] //reels_objects[index].videoSrc,
                      ),
                  Positioned(
                    left: w / 30,
                    bottom: h / 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            _reels_items[index]["description"] + "\n ",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            // reels_objects[index].description,
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                height: 2,
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            CircleAvatar(
                              child: ClipRRect(
                                child: Image.network(
                                  _reels_items[index]["profilePic"],
                                  //reels_objects[index].profilePic,
                                  width: w * 0.5,
                                  height: h * 0.5,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(w * 1),
                              ),
                              radius: 14,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: h * 0.27),
                              padding: EdgeInsets.only(right: 1.0),
                              child: Text(
                                _reels_items[index]["channelName"],
                                //  reels_objects[index].channelName,
                                style: GoogleFonts.ubuntu(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 1),
                            if (_reels_items[index]["isVerified"]
                            //reels_objects[index].isVerified
                            )
                              Icon(
                                Icons.verified,
                                size: 15,
                                color: Colors.blue,
                              ),
                            SizedBox(width: 2),
                          ],
                        ),
                        Row(
                          children: [],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: w / 80,
                    bottom: h / 7,
                    child: Column(
                      children: [
//<<<<<<< HEAD
                        liked == true
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    liked = !liked;
                                  });
                                  LikeServices().unLikeReels(
                                      _reels_items[index]["id"],
                                      // reels_objects[index].id,
                                      altUserId,
                                      altUserId);
                                }, //---------------------------------------------------
                                icon: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    liked = !liked;
                                  });
                                  LikeServices().likeReels(
                                      _reels_items[index]["id"],
                                      altUserId,
                                      altUserId);
                                }, //----------------------
                                icon: IconButton(
                                  icon: Icon(Icons.favorite_outline_rounded),
                                  color: Colors.white,
                                  onPressed: () {
                                    print("index");
                                    print(index);
                                  },
                                ),
                              ),
                        Text(
                          Numeral(_reels_items[index]["likes"]).value(),
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              height: 1,
                              fontWeight: FontWeight.w100),
                        ),
//======= Some problem here..............................................
                        /*      FutureBuilder(
                          future: LikeServices().reelsLikeChecker(likeId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              print(1);
                              return Icon(Icons.favorite);
                            } else {
                              if (snapshot == null) {
                                print(10);
                              }
                              print(liked.toString()+DateTime.now().toString());
                              // print(
                              //     snapshot.data[FieldPath.fromString("liked")]);
                              // print("snapshot.data");
                              setState(() {
                                liked = snapshot.data['liked']??false;
                              });
                              return liked == true
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          liked = !liked;
                                        });
                                        LikeServices().unLikeReels(
                                            reels_objects[index].id,
                                            reels_objects[index].channelId,
                                            altUserId);
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
                                        print(reels_objects[index].id+
                                            reels_objects[index].channelId+
                                            altUserId);
                                        LikeServices().likeReels(
                                            reels_objects[index].id,
                                            reels_objects[index].channelId,
                                            altUserId);
                                      },
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: primary,
                                      ),
                                    );
                            }
                          },
                        ),*/
//>>>>>>> 9f2164bf502e9ec41dcc5db14c2606bd5ff2b1bc
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: () async {
                            parameters = ['30s'];
                            parameters.add(_reels_items[index]["id"]);
                            print(parameters);
                            await _dynamicLinkService
                                .createDynamicLink(parameters)
                                .then((value) {
                              dynamic_link = value;
                            });
                            //here------------- ------------------    ---------------- -- --- --- --    ----   ---- --- -- -- - - - - - -----
                            Share.share(dynamic_link);

                            //-----------------------------
                          }, //reels share function
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Edit30s(_reels_items[index]["id"])),
                            );
                          }, //reels edit function
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: () {
                            if (widget.channelId == altUserId) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Are you sure?",
                                      style: GoogleFonts.ubuntu(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      //message,
                                      "Do You want to delete this 30s video?",
                                      style: GoogleFonts.ubuntu(),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "OK",
                                          style: GoogleFonts.ubuntu(
                                              color: primary),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deletenow("reels",
                                              _reels_items[index]["id"]);
                                        },
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Cancel",
                                          style: GoogleFonts.ubuntu(
                                              color: primary),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }, //reels report/delete function
                          icon: Icon(
                            widget.channelId == altUserId
                                ? Icons.delete
                                : Icons.flag_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              },
              // autoplay: true,
              //  itemWidth:DeviceSize(context).width*0.5,
              itemCount: swiper_number_of_items = _reels_items.length,
              scrollDirection: Axis.vertical,
              //loop: false,
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              ),
            ),
    );
  }
}

/**/
