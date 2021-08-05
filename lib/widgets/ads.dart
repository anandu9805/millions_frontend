import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/admodel.dart';
import 'package:url_launcher/url_launcher.dart';
import "dart:math";

class AdPost extends StatefulWidget {
  @override
  _AdPostState createState() => _AdPostState();
}

class _AdPostState extends State<AdPost> {
  List<String> postAdList = [];
  final _random = new Random();
  String randomAdId;
  bool _isLoading = false;

  Future<void> getDetails() async {
    return FirebaseFirestore.instance
        .collection('post-ads')
        .where('showAdIn', whereIn: ['Kollam', 'KL', 'IN'])
        .get()
        .then((value) {
          value.docs.forEach((element) {
            postAdList.add(element['id']);
          });
        })
        .catchError((onError) {
          print(onError);
        });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getDetails().whenComplete(() => setState(() {
          randomAdId = postAdList[_random.nextInt(postAdList.length)];
          _isLoading = false;
        }));
  }

  AdPostModel adpost;
  //get _usersStream => FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  //CollectionReference ads = FirebaseFirestore.instance.collection("post-ads").where("showAdIn","in",[user?.district || "Kollam", user?.state || "KL", user?.country || "IN",  "All Videos", ] || ["Kollam", "KL", "IN", "All Videos"]).get();
  CollectionReference ads = FirebaseFirestore.instance.collection("post-ads");
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Text(
                "Loading Ad...",
                style: GoogleFonts.ubuntu(fontSize: 20),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: BoxDecoration(
              border: Border.all(color: primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: FutureBuilder<DocumentSnapshot>(
              future: ads.doc(randomAdId).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Center(
                          child: Text("Something went wrong!",
                              style: GoogleFonts.ubuntu(fontSize: 20))));
                }

                if (snapshot.hasData && !snapshot.data.exists) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Center(
                          child: Text("Ad does not exist!",
                              style: GoogleFonts.ubuntu(fontSize: 20))));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data.data() as Map<String, dynamic>;
                  adpost = AdPostModel.fromDoc(data);
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          launch(adpost.adLink);
                        },
                        child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              adpost.photoSrc,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  //padding: const EdgeInsets.only(top: 20, bottom:20),
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: primary,
                                      value: loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              width: MediaQuery.of(context).size.width * 0.1,
                              //color: primary,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'AD',
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              adpost.description,
                              style: GoogleFonts.ubuntu(
                                  color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }

                return Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Center(
                    child: Text(
                      "Loading Ad...",
                      style: GoogleFonts.ubuntu(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
