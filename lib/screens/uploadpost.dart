import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/screens/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; //to use json
import '../constants/colors.dart';
import '../model/newpost_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  bool _isLoading = false;
  // var currentuserid =
  //     "4C4iLByizTPLBBlP4rssrwGTISb2"; //the id of the logged in user
  //var currentuserid ="Pon1uG0eNnhf9TLsps0jtScndtN2";
  PickedFile pickedImageFile;
  String fileName;
  List posts = [];
  File _imageFile;
  String url;
//List currentUserChannelDetails=[];
  ChannelModel channelDetails;
  bool uploadComplete = false;
  TextEditingController decsiptionController;

  //List<String> comments = ['Enabled', 'Disabled'];
  String commentStatus = 'Allowed';
  String description = " ";
  bool allowcomment = true;
  var percentage_uploaded = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCurrentUserChannelDetails();
    uploadComplete = false;
    _isLoading = false;
    decsiptionController = TextEditingController();
  }

  Future<String> getCurrentUserChannelDetails() async {
    try {
      FirebaseFirestore.instance
          .collection('channels')
          .doc(altUserId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        channelDetails = ChannelModel.fromDoc(data);
      });
    } catch (e) {
      return "Channel Error";
    }
  }

  void _fromgallery() async {
    final _picker = ImagePicker();

    pickedImageFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);

    fileName = pickedImageFile.path.split('/').last;

    //print(fileName);

    setState(() {
      _imageFile = File(pickedImageFile.path);
      //  print(_imageFile);

      uploadComplete = true;
    });
  }

  void _selectImage() async {
    final _picker = ImagePicker();
    pickedImageFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);
    fileName = pickedImageFile.path.split('/').last;

    // print(fileName);

    setState(() {
      _imageFile = File(pickedImageFile.path);

      uploadComplete = true;
    });
  }

  void upload() async {
    var newId = FirebaseFirestore.instance
        .collection('posts')
        .doc(); //to get the id of the document we are going to create in the collection
    setState(() {
      _isLoading = true;
    });

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    print(
        "postfile name----------------------------------------------------------");
    print(fileName);
    print(
        "postfile format-----------------------------------------------------------");
    print(fileName.split('.').last);

    firebase_storage.Reference ref = storage.ref(
        'assets/${altUserId}/posts/${newId.id}.${fileName.split('.').last}');
    firebase_storage.UploadTask uploadTask = ref.putFile(_imageFile);
    uploadTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');

      setState(() {
        _isLoading = true;
        percentage_uploaded =
            ((snapshot.bytesTransferred / snapshot.totalBytes) * 100).round();
      });
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(uploadTask.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();

      description =
          decsiptionController.text.isEmpty ? " " : decsiptionController.text;

      posts.add(NewPost(description, _imageFile, commentStatus));

      await FirebaseFirestore.instance.collection('posts').doc(newId.id).set({
        'category': "post",
        'channelId': channelDetails.id,
        'channelName': channelDetails.channelName,
        'comments': 0,
        'country': channelDetails.country,
        'date': DateTime.now(),
        'description': posts[0].description,
        'disLikes': 0,
        'generatedThumbnail': " ",
        'id': newId.id,
        'isComments': posts[0].comment_enabled,
        'isVerified': channelDetails.isVerified,
        'isVisible': "Public",
        'language': 'English',
        'likes': 0,
        'photoSrc': url,
        'profilePic': channelDetails.profilePic,
        'subscribers': channelDetails.subsribers,
        'thumbnail': " ",
        'title': "Post by ${channelDetails.channelName}",
        'videoScore': 0,
        'views': 0,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      _isLoading = false;
    }).catchError((onError) {
      print(onError);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: _isLoading
          ? Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 4,
                child: LiquidCircularProgressIndicator(
                  value: percentage_uploaded / 100,
                  // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(primary),
                  // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.white,
                  // Defaults to the current Theme's backgroundColor.
                  borderColor: primary,
                  borderWidth: 5.0,
                  direction: Axis.vertical,
                  // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "$percentage_uploaded%",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          // Center(
          //     child: LoadingBouncingGrid.circle(
          //     borderColor: primary,
          //     backgroundColor: Colors.white,
          //     borderSize: 10,
          //     size: 100,
          //     duration: Duration(milliseconds: 1800),
          //   ))
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 60, 0, 30),
                      child: Text(
                        'Create Post',
                        style: GoogleFonts.ubuntu(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      )),
                  //-----------

                  if (_imageFile != null)
                    Container(
                      child: Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
                    ),
                  if (_imageFile == null)
                    InkWell(
                      onTap: () {
                        Future<void> _showMyDialog() async {
                          return showDialog<void>(
                            context: context,
                            //barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Select a photo',
                                  style: TextStyle(color: primary),
                                  textAlign: TextAlign.left,
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text(
                                          'Please select a photo from your gallery or capture one.'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Take a picture',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    onPressed: () {
                                      _selectImage();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Gallery',
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 16,
                                          color: primary,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    onPressed: () {
                                      _fromgallery();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        //------------

                        _showMyDialog();
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(0xFFF5F5F5),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Icon(
                                    Icons.cloud_upload,
                                    color: primary,
                                    size: 40,
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Upload an Image',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.ubuntu(
                                        color: primary,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Your photos will be public after you publish them',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.ubuntu(
                                  // color: primary,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      'By submitting your photo to Millions, you acknowledge that you agree to Millions\'s Terms of Service and Community Guidelines',
                      style: GoogleFonts.ubuntu(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Text(
                      'Description',
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      maxLines: 5,
                      minLines: 4,
                      controller: decsiptionController,
                      obscureText: false,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Text(
                      'Comments',
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        //width: 20,
                        decoration: BoxDecoration(
                          // color: Colors.transparent,
                          border: Border.all(
                            color: primary,
                            width: 1,
                          ),
                        ),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          elevation: 0,
                          style: GoogleFonts.ubuntu(),
                          // hint: Text('Please choose a location'), // Not necessary for Option 1
                          value: commentStatus,
                          onChanged: (newValue) {
                            setState(() {
                              commentStatus = newValue.toString();
                            });
                          },
                          items: comments.map((cmnt) {
                            return DropdownMenuItem(
                              child: new Text(
                                cmnt,
                                style: GoogleFonts.ubuntu(color: Colors.black),
                              ),
                              value: cmnt,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  uploadComplete
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              print("starting");
                              upload();
                            },
                            style: ElevatedButton.styleFrom(primary: primary),
                            child: Text(
                              'Done',
                              style: GoogleFonts.ubuntu(),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(primary: primary),
                            child: Text(
                              'Upload',
                              style: GoogleFonts.ubuntu(),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
