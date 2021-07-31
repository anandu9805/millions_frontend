import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/size.dart';
import 'package:millions/screens/content_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:millions/screens/uploadvideo.dart';
import 'package:millions/services/likeServices.dart';
import '../model/reels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../services/dynamiclinkservice.dart';

class Shorts extends StatefulWidget {
  @override
  _ShortsState createState() => _ShortsState();
}

class _ShortsState extends State<Shorts> {
  SwiperController _scrollController = SwiperController();

  //ScrollController _scrollController=ScrollController();
  var currentuserid =
      "Pon1uG0eNnhf9TLsps0jtScndtN2"; //the id of the logged in user
  // var currentuserid = "DEyDJLaskaSXV5kMBLXSGBBZC062";
  List following_details = [];
  bool liked = false;
  String likeId;
  var _perpage = 10;
  List<Reels> reels_objects = [];
  List<DocumentSnapshot> _reels_items = [];
  DocumentSnapshot _lastdocument;
  var _isLoading = true;
  int number_of_items, swiper_number_of_items;
  String dynamic_link;
  List parameters=['30s'];

  @override
  void initState() {
    print("going to call");

GetCurrentUserDetails();
    _getReels();
    getFollowingdetails();




    super.initState();
  }



  Future<String> GetCurrentUserDetails() async {//get current user details here
    try {
        print("hello---------------------------------------------------------------------------------------------");
    await  FirebaseFirestore.instance
          .collection('channels').doc(currentuserid)
          .get().then((value) => print(value));

    } catch (e) {
      return "Follow";
    }
  }

  Future<String> getFollowingdetails() async {
    try {
      //  print("hello");
     await FirebaseFirestore.instance
          .collection('followers')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          //  print("in");
          if (doc['follower'] == currentuserid)
            following_details.add(doc['channel']);
        });
      });
    } catch (e) {
      return "Follow";
    }
  }

  _getReels() async {
    Query q = FirebaseFirestore.instance
        .collection('reels')
        .orderBy("date")
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
                      src: _reels_items[index]
                          ["videoSrc"] //reels_objects[index].videoSrc,
                      ),
                  Positioned(
                    left: w / 30,
                    bottom: h / 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            child: Image.network(
                              _reels_items[index]["profilePic"],
                              //reels_objects[index].profilePic,
                              width: w * 1,
                              height: h * 1,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(w * 1),
                          ),
                          radius: 20,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              _reels_items[index]["channelName"],
                              //  reels_objects[index].channelName,
                              style: GoogleFonts.ubuntu(color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            if (_reels_items[index]["isVerified"]
                            //reels_objects[index].isVerified
                            )
                              Icon(
                                Icons.verified,
                                size: 15,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            _reels_items[index]["channelId"]!=currentuserid ? FlatButton(
                              color: primary,
                              onPressed: () {
                                if (!following_details
                                    .contains(_reels_items[index]["channelId"]
                                        // reels_objects[index].channelId
                                        )) {
                                  setState(() {
                                    following_details
                                        .add(_reels_items[index]["channelId"]);
                                  });
                                  FirebaseFirestore.instance
                                      .collection('followers')
                                      .doc(currentuserid)
                                      .set({
                                    'channel': _reels_items[index]["channelId"],
                                    'date': DateTime.now(),
                                    'follower': currentuserid
                                  });
                                } else {
                                  //                        print("already following");
                                }
                              },
                              child: Text(
                                !following_details.contains(
                                        _reels_items[index]["channelId"])
                                    ? 'Follow'
                                    : 'Following',
                                style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    height: 1,
                                    fontWeight: FontWeight.w500),
                              ),
                            ):FlatButton(child:Text('Following'),color: Colors.black12,)
                          ],
                        ),
                        Text(
                          _reels_items[index]["description"],
                          // reels_objects[index].description,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              height: 1,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: w / 80,
                    bottom: h / 7,
                    child: Column(
                      children: [
                        liked == true
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    liked = !liked;
                                  });
                                  LikeServices().unLikeReels(
                                      _reels_items[index]["id"],
                                      // reels_objects[index].id,
                                      currentuserid,
                                      currentuserid);
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
                                      currentuserid,
                                      currentuserid);
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
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: () async{
                            parameters=['30s'];
                            parameters.add(_reels_items[index]["id"]);
                            print(parameters);
                           await _dynamicLinkService.createDynamicLink(parameters).then((value){
                              dynamic_link=value;
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
                          onPressed: () {}, //reels report function
                          icon: Icon(
                            Icons.flag_outlined,
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
