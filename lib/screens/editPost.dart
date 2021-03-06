import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/widgets/inputField.dart';

class EditPost extends StatefulWidget {
  //const EditPost({ Key? key }) : super(key: key);
  final String myPostId;
  EditPost(this.myPostId);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String commentStatus;
  bool _isLoading;
  PostDetail post;
  TextEditingController descontroller;

  Future<void> getDetails() async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.myPostId)
        .get()
        .then((value) {
      post = PostDetail.fromMap(value.data());
      commentStatus = post.isComments;
      print(post.isComments + "--" + widget.myPostId);
      descontroller = TextEditingController(text: post.description);
    });
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

  void updatePost() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.myPostId)
          .update({
        'isComments': commentStatus,
        'description': descontroller.text,
      }).then((value) {
        _showToast(context, "Post Edited Successfully");
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }).catchError(
              (error) => _showToast(context, "Failed to edit post: $error"));
    } catch (e) {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getDetails().whenComplete(() => setState(() {
          _isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingBouncingGrid.circle(
              borderColor: primary,
              backgroundColor: Colors.white,
              borderSize: 10,
              size: 100,
              duration: Duration(milliseconds: 1800),
            ))
          : SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18, top: 20),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Edit Post",
                          style: GoogleFonts.ubuntu(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Post Description',
                          style: GoogleFonts.ubuntu(),
                        ),
                        InputField("", descontroller, 6),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          'Comments',
                          style: GoogleFonts.ubuntu(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: primary,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              dropdownColor: Colors.white,
                              elevation: 0,
                              style: GoogleFonts.ubuntu(),
                              value: commentStatus,
                              onChanged: (newValue) {
                                setState(() {
                                  commentStatus = newValue.toString();
                                  print("object" + commentStatus);
                                });
                              },
                              items: comments.map((cmnt) {
                                return DropdownMenuItem(
                                  child: new Text(
                                    cmnt,
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.black),
                                  ),
                                  value: cmnt,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: primary),
                        onPressed: () {
                          updatePost();
                        },
                        child: Text(
                          "Update",
                          style: GoogleFonts.ubuntu(fontSize: 15),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}
