import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/user.dart';
//import 'package:millions/widgets/appbar_others.dart';

import '../widgets/photos.dart';

class Screen11 extends StatefulWidget {

  //---------------------------------------------------------------------------------------------------------------------
  String postId;

  Screen11(String id1) {
    this.postId = id1;
  }

  //---------------------------------------------------------------------------------------------------------------------

  @override
  _Screen11State createState() => _Screen11State();
}

class _Screen11State extends State<Screen11> {

  void initState() {
    //---------------------------------------------------------------------------------------------------------------------
    if (widget.postId != null) {
      _getPostFromId();
    }
    //---------------------------------------------------------------------------------------------------------------------
    super.initState();
  }


  //---------------------------------------------------------------------------------------------------------------------
  PostDetail post2;
  var _isLoading = true;

  _getPostFromId() //to get the post from the id passed through the dynamic link
  async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      post2 = PostDetail.fromMap(documentSnapshot.data());
    });
    setState(() {
      _isLoading = false;
    });
    print(' post2');
    print(post2);
    print(post2.id);

  }

  //---------------------------------------------------------------------------------------------------------------------

  UserDetail user;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;
    return Scaffold(

      body: (_isLoading == false || widget.postId == null)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.postId != null)
                    SizedBox(height:30,),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, left: 5),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Posts',
                            style: GoogleFonts.ubuntu(
                                fontSize: 25, color: Colors.black54),
                          )),
                    ),
                  ),

                  // Container(
                  //   height: (h) - ((h) * (1 / 8)) - ((h) * (1 / 8.5)),
                  //   child: ListView.builder(
                  //     itemBuilder: (context, index) {
                  //       return Photos(index);
                  //     },
                  //     scrollDirection: Axis.vertical,
                  //     itemCount: 5,
                  //   ),
                  // ),
                  //---------------------------------------------------------------------------------------------------------------------
                  if (widget.postId != null)
                    Container(
                      child: Photos(post2),
                    ),
                  //---------------------------------------------------------------------------------------------------------------------
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .where("isVisible", isEqualTo: "Public")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        //print(snapshot.data.size);
                        return ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: snapshot.data.docs.map((doc) {
                            PostDetail photoItems =
                                PostDetail.fromMap(doc.data());
                            return Container(
                              child: Photos(photoItems),
                            );
                          }).toList(),
                        );
                      } else {
                        // print(123);
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
                ],
              ),
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
