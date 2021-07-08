import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:millions/model/admodel.dart';
import 'package:millions/model/video.dart';
import 'package:millions/services/video-services.dart';
import 'package:millions/widgets/ads.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/photos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Screen5 extends StatefulWidget {
  @override
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  @override
  Widget build(BuildContext context) {
    // final currentuser=FirebaseAuth.instance.currentUser;
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // final currentUserDetails =users.where('email',isEqualTo:currentuser.email );

    // var ifphotos = true;
    var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      // scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  //height: (h) * 0.5,
                  //width: double.infinity,
                  child: AdPost(),
                  // child: Text(
                  //   'Add banner comes here',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  //color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Hello Anandu ',
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black54),
                      )),
                )
              ],
            ),
            color: Colors.white,
            width: double.infinity,
            //height: (h) * 1 / 8.5,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('videos').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // List<Video> data =
                  //     snapshot.data.docs;
                  // Video data = snapshot.data.doc;
                  children: snapshot.data.docs.map((doc) {
                    Video videoItems = Video.fromMap(doc.data());
                    // print(videoItems.category);

                    // return ListTile(
                    //   title: Text("${videoItems.category}"),

                    // );
                    return VideoCard(
                      video: videoItems,
                    );
                  }).toList(),
                );

              } else {
                print(123);
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            // future: VideoServices.getAllVideos(),
          ),
        ],
      ),
    );
  }
}
