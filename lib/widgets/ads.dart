import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/admodel.dart';
import 'package:url_launcher/url_launcher.dart';

class AdPost extends StatefulWidget {
  //const AdPost({ Key? key }) : super(key: key);

  @override
  _AdPostState createState() => _AdPostState();
}

class _AdPostState extends State<AdPost> {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        //headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  AdPostModel adpost;
  //get _usersStream => FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  //CollectionReference ads = FirebaseFirestore.instance.collection("post-ads").where("showAdIn","in",[user?.district || "Kollam", user?.state || "KL", user?.country || "IN",  "All Videos", ] || ["Kollam", "KL", "IN", "All Videos"]).get();
  CollectionReference ads = FirebaseFirestore.instance.collection("post-ads");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: ads.doc(altAdPostId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Something went wrong",
            style: GoogleFonts.ubuntu(fontSize: 20),
          );
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text(
            "Ad does not exist",
            style: GoogleFonts.ubuntu(fontSize: 20),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
          adpost = AdPostModel.fromDoc(data);
          return InkWell(
            onTap: () {
              _launchInBrowser(adpost.adLink);
            },
            child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(adpost.photoSrc)),
          );
        }

        return Text(
          'Loading Ad..',
          style: GoogleFonts.ubuntu(color: Colors.black),
        );
      },
    );
  }
}
