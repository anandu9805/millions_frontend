import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:millions/model/video.dart';
import 'package:millions/services/video-services.dart';
import 'package:millions/widgets/videoCard.dart';


class Screen5 extends StatefulWidget {
  @override
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  height: (h) * 1 / 14,
                  width: double.infinity,
                  child: Text(
                    'Add banner comes here',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Hello Anandu',
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      )),
                ),
              ],
            ),
            color: Colors.white,
            width: double.infinity,
            height: (h) * 1 / 8.5,
          ),
          StreamBuilder(
            stream: VideoServices().getAllVideos(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((doc) {
                    Video videoItems = Video.fromMap(doc.data());
                    return VideoCard(
                      video: videoItems,
                    );
                  }).toList(),
                );
              } else {
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
