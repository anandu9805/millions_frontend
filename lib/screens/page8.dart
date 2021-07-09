import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/verification.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:millions/widgets/photos.dart';

class Page8 extends StatefulWidget {
  final String channelId;
  Page8(this.channelId);
  @override
  _Page8State createState() => _Page8State();
}

class _Page8State extends State<Page8> {
  Color active = primary,
      inactive = Colors.black,
      vtextcolor = primary,
      rtextcolor = Colors.black,
      ptextcolor = Colors.black;
  int currentSelection = 1;
  Stream<QuerySnapshot<Map<String, dynamic>>> videoStream;
  Stream<QuerySnapshot<Map<String, dynamic>>> postStream;
  //String channelId = 'Pon1uG0eNnhf9TLsps0jtScndtN2';
  String userId = "4C4iLByizTPLBBlP4rssrwGTISb2";
  String exists = "Follow";

  Future<DocumentSnapshot<Map<String, dynamic>>> channelDetails, followDetails;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  Future<String> checkExist(String docID) async {
    try {
      await FirebaseFirestore.instance
          .doc("followers/$docID")
          .get()
          .then((doc) {
        if (doc.exists)
          exists = "Unfollow";
        else
          exists = "Follow";
      });
      return exists;
    } catch (e) {
      return "Follow";
    }
  }

  @override
  initState() {
    super.initState();
    checkExist(userId + "_" + widget.channelId).then((value) => exists = value);
    videoStream = FirebaseFirestore.instance
        .collection("videos")
        .where('channelId', isEqualTo: widget.channelId)
        .where("isVisible", isEqualTo: "Public")
        .orderBy("date", descending: true)
        .snapshots();
    postStream = FirebaseFirestore.instance
        .collection("posts")
        .where("isVisible", isEqualTo: "Public")
        .where("channelId", isEqualTo: widget.channelId)
        .orderBy("date", descending: true)
        .snapshots();
    channelDetails = FirebaseFirestore.instance
        .collection("channels")
        .doc(widget.channelId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                  height: 142,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/million logo with millions.png",
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            ListTile(
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen14()),
                );
              },
            ),
            ListTile(
              title: Text('Payment Verification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentVerifcationPage()),
                );
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (h) * (1 / 13),
        ),
        child: AppBar(
          leading: Container(
            color: Colors.white,
            width: w / 4,
            child: InkWell(
              child: Image.asset(
                'images/million final logo with out millions.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.centerRight,
              ),
              onTap: () {
                openDrawer();
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: IconButton(
                  icon: Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //go to search screen
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: InkWell(
                child: CircleAvatar(
                  child: ClipRRect(
                    child: Image.network(
                      altProfilePic,
                      // 'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
                      width: w * 0.3,
                      height: w * 0.3,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(w * 0.1),
                  ),
                  // backgroundColor: Colors.black,
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
      ),

      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,
      // key: scaffoldKey,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: channelDetails,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          "Something went wrong",
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }

                      if (snapshot.hasData && !snapshot.data.exists) {
                        //if()
                        return Text(
                          "Channel does not exist",
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data.data() as Map<String, dynamic>;
                        ChannelModel channel = ChannelModel.fromDoc(data);
                        //() async=>{exists = await checkExist(userId + "_" + channel.id)};
                        return Container(
                          width: double.infinity,
                          height: 165,
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      (channel.channelArt == null ||
                                              channel.channelArt.isEmpty)
                                          ? altChannelArt
                                          : channel.channelArt,
                                    ),
                                    //  'https://motionarray.imgix.net/preview-75634-8YcoQ8Fyf3_0000.jpg'),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        child: ClipRRect(
                                          child: Image.network(
                                            (channel.profilePic == null ||
                                                    channel.profilePic.isEmpty)
                                                ? altProfilePic
                                                : channel.profilePic,
                                            //data['profilePic'],
                                            width: w * 1,
                                            height: h * 1,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(w * 1),
                                        ),
                                        // backgroundColor: Colors.black,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 50, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  //username,
                                                  channel.channelName,
                                                  style: GoogleFonts.ubuntu(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 4, 0, 0),
                                                  child: Text(
                                                    channel.subsribers
                                                            .toString() +
                                                        ' Subscribers',
                                                    style: GoogleFonts.ubuntu(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      print('Button Pressed');
                                                      //print(currentSelection);
                                                    },
                                                    child: Text(
                                                      exists,
                                                      style: GoogleFonts.ubuntu(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: Text(
                          "Loading Channel Details..",
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentSelection = 1;
                                vtextcolor = active;
                                ptextcolor = inactive;
                                rtextcolor = inactive;
                              });
                            },
                            child: Text(
                              'Videos',
                              style: GoogleFonts.ubuntu(
                                color: vtextcolor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentSelection = 2;
                                rtextcolor = active;
                                ptextcolor = inactive;
                                vtextcolor = inactive;
                              });
                            },
                            child: Text(
                              '30s',
                              style: GoogleFonts.ubuntu(
                                color: rtextcolor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentSelection = 3;
                                ptextcolor = active;
                                vtextcolor = inactive;
                                rtextcolor = inactive;
                              });
                            },
                            child: Text(
                              'Posts',
                              style: GoogleFonts.ubuntu(
                                color: ptextcolor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    height: (h) / 1.9,
                    child: StreamBuilder(
                      stream:
                          ((currentSelection == 1) || (currentSelection == 2))
                              ? videoStream
                              : postStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null || snapshot.data.size < 1)
                          return Center(
                              child: Text(
                            "Nothing To Show !",
                            style: GoogleFonts.ubuntu(fontSize: 15),
                          ));
                        if (snapshot.hasData) {
                          //print(currentSelection);
                          return new ListView(
                            //physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // List<Video> data =
                            //     snapshot.data.docs;
                            // Video data = snapshot.data.doc;
                            children: snapshot.data.docs.map((doc) {
                              // print(snapshot.data.size);

                              if ((currentSelection == 1) ||
                                  (currentSelection == 2)) {
                                Video videoItems = Video.fromMap(doc.data());
                                return VideoCard(
                                  video: videoItems,
                                );
                              } else {
                                //print("No of posts : "+snapshot.data.size.toString());
                                PostDetail photoItems =
                                    PostDetail.fromMap(doc.data());
                                return Container(
                                  child: Photos(photoItems),
                                );
                              }

                              // print(videoItems.category);

                              // return ListTile(
                              //   title: Text("${videoItems.category}"),

                              // );
                            }).toList(),
                          );
                          // },
                          // scrollDirection: Axis.vertical,
                          // itemCount: snapshot.data.size,
                          // );
                        } else {
                          print(123);
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primary,
                              ),
                            ),
                          );
                        }
                      },
                      // future: VideoServices.getAllVideos(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}