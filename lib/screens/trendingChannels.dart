import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/screens/page8.dart';

class TrendingChannels extends StatefulWidget {
  @override
  _TrendingChannelsState createState() => _TrendingChannelsState();
}

class _TrendingChannelsState extends State<TrendingChannels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //AppBarOthers(),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 12, bottom: 20),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Trending Channels',
                      style: GoogleFonts.ubuntu(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                    )),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("channels")
                  .orderBy("channelScore", descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  //print(snapshot.data.size);
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((doc) {
                      ChannelModel trendingChannel =
                          ChannelModel.fromDoc(doc.data());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Page8(trendingChannel.id)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                          child: Container(
                            color: Colors.white,
                            height: 170,
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: Card(
                              elevation: 0,
                              color: Colors.grey,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      (trendingChannel.channelArt == null ||
                                              trendingChannel
                                                  .channelArt.isEmpty)
                                          ? altChannelArt
                                          : trendingChannel.channelArt,
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                              (trendingChannel.profilePic ==
                                                          null ||
                                                      trendingChannel
                                                          .profilePic.isEmpty)
                                                  ? altProfilePic
                                                  : trendingChannel.profilePic,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  trendingChannel.channelName
                                                              .length >
                                                          17
                                                      ? trendingChannel
                                                              .channelName
                                                              .substring(
                                                                  0, 17) +
                                                          "...."
                                                      : trendingChannel
                                                          .channelName,
                                                  //maxLines: 2,
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.ubuntu(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                if (trendingChannel.isVerified)
                                                  Icon(
                                                    Icons.verified,
                                                    size: 20,
                                                    color: Colors.blue,
                                                  ),
                                              ],
                                            ),
                                            Text(
                                              NumberFormat.compact()
                                                      .format(trendingChannel
                                                          .subsribers)
                                                      .toString() +
                                                  ' Followers',
                                              style: GoogleFonts.ubuntu(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  // print(123);
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
