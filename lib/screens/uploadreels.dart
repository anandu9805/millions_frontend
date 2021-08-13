import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/screens/home.dart';
import '../model/newreels_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import './trimmer_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadReel extends StatefulWidget {
  final File file_to_upload, thumbnail_from_preview;
  var duration;

  UploadReel(this.file_to_upload, this.thumbnail_from_preview, this.duration);

  @override
  _UploadReelState createState() => _UploadReelState();
}

class _UploadReelState extends State<UploadReel> {
  bool _isLoading = false;

  // var currentuserid =
  //     "4C4iLByizTPLBBlP4rssrwGTISb2"; //the id of the logged in user
  //var currentuserid = "Pon1uG0eNnhf9TLsps0jtScndtN2";
  var currentuserid = FirebaseAuth.instance.currentUser.uid;
  String fileName = null;
  String url;
  //List currentUserChannelDetails = [];
  ChannelModel channelDetails;
  List reelslist = [];
  File _videoFile;
  bool uploadComplete = false;
  TextEditingController decsiptionController;
  TextEditingController titleController;
  String selectedCountry = 'Choose Your Country';
  //List<String> lanuages = ['Malayalam', 'English', 'Hindi'];
  //List<String> comments = ['Enabled', 'Disabled'];
  //List<String> category = ['All Videos', 'Entertainment', 'Comedy'];

  String selectedLanguage = 'English';
  String commentStatus = 'Allowed';
  String selectedCategory = 'All Videos';

  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 100;
  File thumbanil = null;
  File thumbanil_temp = null;
  String _tempDir;
  String thumnailpath;
  String thumnail_image_name;
  String thumbnail_url;
  var percentage_uploaded = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    decsiptionController = TextEditingController();
    titleController = TextEditingController();
    getTemporaryDirectory().then((d) {
      _tempDir = d.path;
      print("_tempDir");
      print(_tempDir);
    });

    getCurrentUserChannelDetails();
    if (widget.file_to_upload != null) {
      _videoFile = widget.file_to_upload;
      thumbanil = widget.thumbnail_from_preview;
      uploadComplete = true;
      fileName = widget.file_to_upload.path.split('/').last;
      thumnail_image_name = widget.thumbnail_from_preview.path.split('/').last;
    }
  }

  void _fromgallery() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getVideo(
      source: ImageSource.gallery,
    );
    // fileName = pickedImageFile.path.split('/').last;
    await getThumbanil(pickedImageFile).then((value) => thumbanil_temp = value);

    //---------------------------------------------------------
    if (widget.file_to_upload == null) {
      Navigator.of(context).push(
        //to trim..............................
        MaterialPageRoute(builder: (context) {
          return TrimmerView(File(pickedImageFile.path), thumbanil_temp);
        }),
      );
    }

//--------------------------------------------------------------
//     setState(() {
//       _videoFile = widget.file_to_upload;
//       thumbanil = thumbanil_temp;
//       uploadComplete = true;
//     });
  }

  void _selectVideo() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getVideo(
      source: ImageSource.camera,
    );

    await getThumbanil(pickedImageFile).then((value) => thumbanil_temp = value);

    //---------------------------------------------------------
    if (widget.file_to_upload == null) {
      Navigator.of(context).push(
        //to trim..............................
        MaterialPageRoute(builder: (context) {
          return TrimmerView(File(pickedImageFile.path), thumbanil_temp);
        }),
      );
    }

//--------------------------------------------------------------
//     setState(() {
//       _videoFile = widget.file_to_upload;
//
//       thumbanil = thumbanil_temp;
//
//       uploadComplete = true;
//     });
  }

  Future<String> getCurrentUserChannelDetails() async {
    try {
      FirebaseFirestore.instance
          .collection('channels')
          .doc(currentuserid )
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

  Future<File> getThumbanil(PickedFile videoFile) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoFile.path,
        thumbnailPath: _tempDir,
        imageFormat: _format,
        maxHeight: 0,
        quality: _quality);

    final file = File(thumbnail);

    print("thumbnail");
    print(file);
    return file;
  }

  void upload() async {
    // if(widget.file_path!=null)
    //   await getThumbanil(widget.file_path).then((value) => thumbanil_temp = value);
    setState(() {
      _isLoading = true;
    });

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref_thumbnail = storage
        .ref('test-reels/${currentuserid }/thumbnails/${thumnail_image_name}');
    firebase_storage.UploadTask uploadTask_thumbnail =
        ref_thumbnail.putFile(thumbanil);
    uploadTask_thumbnail.whenComplete(() async {
      thumbnail_url = await ref_thumbnail.getDownloadURL();

      firebase_storage.Reference ref =
          storage.ref('test-reels/${currentuserid }/${fileName}');
      firebase_storage.UploadTask uploadTask = ref.putFile(_videoFile);
      uploadTask.snapshotEvents.listen(
          (firebase_storage.TaskSnapshot snapshot) {
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
        print("hello1");
        reelslist.add(NewReel(
            titleController.text,
            decsiptionController.text,
            selectedCountry,
            selectedLanguage,
            commentStatus,
            'Public',
            selectedCategory,
            _videoFile));
        print("reels: $reelslist");

        var newId = FirebaseFirestore.instance
            .collection('reels')
            .doc(); //to get the id of the document we are going to create in the collection
        print("hello2");
        print(channelDetails.channelName);
        await FirebaseFirestore.instance.collection('reels').doc(newId.id).set({
          'category': reelslist[0].category,
          'channelId': channelDetails.id,
          'channelName': channelDetails.channelName,
          'comments': 0,
          'country': selectedCountry,
          'date': DateTime.now(),
          'description': reelslist[0].description,
          'disLikes': 0,
          'duration': (widget.duration / 1000).round(), //calculate
          'generatedThumbnail': thumbnail_url, //generate
          'id': newId.id,
          'isComments': reelslist[0].commentallowed,
          'isVerified': channelDetails.isVerified,
          'isVisible': reelslist[0].visibility,
          'language': selectedLanguage,
          'likes': 0,

          'profilePic': channelDetails.profilePic,
          'shortLink': url, //to be filled
          'subscribers': channelDetails.subsribers,
          'thumbnail': thumbnail_url,
          'title': reelslist[0].title,

          'videoScore': 0,
          'videoSrc': url,
          'views': 0,
        });
        print("hello3");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }).catchError((onError) {
        print(onError);
      });
    }).catchError((onError) {
      print(onError);
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    //print("_videoFile $_videoFile");
    return Scaffold(
      key: scaffoldKey,
      body: _isLoading
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: LoadingBouncingGrid.circle(
                    borderColor: primary,
                    backgroundColor: Colors.white,
                    borderSize: 10,
                    size: 100,
                    duration: Duration(milliseconds: 1800),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "$percentage_uploaded%",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
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
                        'Upload 30s',
                        style: GoogleFonts.ubuntu(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      )),

                  //----------------------
                  // thumbanil != null?
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _videoFile != null
                        ? Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: double.infinity,
                              height: 50,
                              //color: primary,
                              // child: Image.file(
                              //   thumbanil,
                              //   fit: BoxFit.fill,
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "30s video selected",
                                  style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Future<void> _showMyDialog() async {
                                return showDialog<void>(
                                  context: context,
                                  //barrierDismissible: false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Select a video',
                                        style: TextStyle(color: primary),
                                        textAlign: TextAlign.left,
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'Please select a video from your gallery or capture one.'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            'Record 30s',
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          onPressed: () {
                                            _selectVideo();
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload,
                                            color: primary,
                                            size: 40,
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Select a 30s video',
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
                                      'Your 30s will be public after you publish them',
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
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      'By submitting your videos to Millions, you acknowledge that you agree to Millions\'s Terms of Service and Community Guidelines',
                      style: GoogleFonts.ubuntu(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Text(
                      'Video Title',
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      controller: titleController,
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
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: Text(
                      'Hint or Error Message',
                      style: GoogleFonts.ubuntu(
                        fontSize: 10,
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
                      ' Country',
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          // optional. Shows phone code before the country name.
                          onSelect: (Country country) {
                            //print('Select country: ${country.displayName}');
                            setState(() {
                              selectedCountry = country.countryCode;
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          selectedCountry,
                          style: GoogleFonts.ubuntu(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Text(
                      'Language',
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                        value: selectedLanguage,
                        onChanged: (newValue) {
                          setState(() {
                            selectedLanguage = newValue.toString();
                          });
                        },
                        items: languages.map((lang) {
                          return DropdownMenuItem(
                            child: new Text(
                              lang,
                              style: GoogleFonts.ubuntu(color: Colors.black),
                            ),
                            value: lang,
                          );
                        }).toList(),
                      ),
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
                        items: comments.map((cmnts) {
                          return DropdownMenuItem(
                            child: new Text(
                              cmnts,
                              style: GoogleFonts.ubuntu(color: Colors.black),
                            ),
                            value: cmnts,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  //   child: Text(
                  //     'Video Visibility',
                  //     style: GoogleFonts.ubuntu(),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 10),
                  //     //width: 20,
                  //     decoration: BoxDecoration(
                  //       // color: Colors.transparent,
                  //       border: Border.all(
                  //         color: primary,
                  //         width: 1,
                  //       ),
                  //     ),
                  //     child: DropdownButton(
                  //       dropdownColor: Colors.white,
                  //       elevation: 0,
                  //       style: GoogleFonts.ubuntu(),
                  //       // hint: Text('Please choose a location'), // Not necessary for Option 1
                  //       value: selectedVisibility,
                  //       onChanged: (newValue) {
                  //         setState(() {
                  //           selectedVisibility = newValue.toString();
                  //         });
                  //       },
                  //       items: visibility.map((visi) {
                  //         return DropdownMenuItem(
                  //           child: new Text(
                  //             visi,
                  //             style: GoogleFonts.ubuntu(color: Colors.black),
                  //           ),
                  //           value: visi,
                  //         );
                  //       }).toList(),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Text(
                      'Video Category',
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue.toString();
                          });
                        },
                        items: categories.map((catg) {
                          return DropdownMenuItem(
                            child: new Text(
                              catg,
                              style: GoogleFonts.ubuntu(color: Colors.black),
                            ),
                            value: catg,
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  uploadComplete
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: ElevatedButton(
                            onPressed: () {
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
                  SizedBox(
                    height: 45,
                  ),
                ],
              ),
            ),
    );
  }
}
