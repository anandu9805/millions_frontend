import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/screens/home.dart';
import '../model/newvideo_model.dart';
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

import 'package:flutter_video_info/flutter_video_info.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isLoading = false;

  // var currentuserid =
  //     "4C4iLByizTPLBBlP4rssrwGTISb2"; //the id of the logged in user
  var currentuserid = "Pon1uG0eNnhf9TLsps0jtScndtN2";
  String fileName;
  String url;
  //List currentUserChannelDetails = [];
    ChannelModel channelDetails;
  List videoslist = [];
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

  final videoInfo = FlutterVideoInfo();
  var info;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  firebase_storage.UploadTask uploading_task;
  var percentage_uploaded = 0;

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
  }

  void _thumbnailfromgallery() async {
    final _picker = ImagePicker();

    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);

    // fileName = pickedImageFile.path.split('/').last;

    //print(fileName);

    setState(() {
      thumbanil = File(pickedImageFile.path);
      //  print(_imageFile);

      //  uploadComplete = true;
    });
  }

  void _fromgallery() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getVideo(
      source: ImageSource.gallery,
    );
    fileName = pickedImageFile.path.split('/').last;
    await getThumbanil(pickedImageFile).then((value) => thumbanil_temp = value);
    info = await videoInfo.getVideoInfo(pickedImageFile.path);
    print("duration");
    print(info.duration);
    setState(() {
      _videoFile = File(pickedImageFile.path);

      // controller = new VideoPlayerController.file(_videoFile);
      // print("controller.value.duration");
      // print(controller.value.duration.toString());

      thumbanil = thumbanil_temp;

      uploadComplete = true;
    });
  }

  void _selectVideo() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getVideo(
      source: ImageSource.camera,
    );
    fileName = pickedImageFile.path.split('/').last;
    await getThumbanil(pickedImageFile).then((value) => thumbanil_temp = value);
    info = await videoInfo.getVideoInfo(pickedImageFile.path);
    print("duration");
    print(info.duration);
    setState(() {
      _videoFile = File(pickedImageFile.path);
      // controller = new VideoPlayerController.file(_videoFile);
      // print("controller.value.duration");
      // print(controller.value.duration.toString());

      thumbanil = thumbanil_temp;

      uploadComplete = true;
    });
  }

  Future<String> getCurrentUserChannelDetails() async {
    try {
      FirebaseFirestore.instance
          .collection('channels')
          .doc(currentuserid)
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
    print("File path-------------------------------------------------------");
    print(file.path);
    thumnail_image_name = file.path.split('/').last;
    print(
        "thumbnail name----------------------------------------------------------");
    print(thumnail_image_name);
    print(
        "thumbnail format----------------------------------------------------------");
    print(thumnail_image_name.split('.').last);
    print(file);
    return file;
  }

  void upload() async {
    var newId = FirebaseFirestore.instance
        .collection('videos')
        .doc(); //to get the id of the document we are going to create in the collection
    setState(() {
      _isLoading = true;
    });

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    thumnail_image_name = thumbanil.path.split('/').last;
    // thumnail_image_name = file.path.split('/').last;
    print(
        "thumbnail name----------------------------------------------------------");
    print(thumnail_image_name);
    print(
        "thumbnail format----------------------------------------------------------");
    print(thumnail_image_name.split('.').last);
    firebase_storage.Reference ref_thumbnail = storage.ref(
        'assets/${currentuserid}/videos/${newId.id}/${newId.id}.${thumnail_image_name.split('.').last}');
    firebase_storage.UploadTask uploadTask_thumbnail =
        ref_thumbnail.putFile(thumbanil);
    uploadTask_thumbnail.whenComplete(() async {
      thumbnail_url = await ref_thumbnail.getDownloadURL();
      //  thumnail_image_name = file.path.split('/').last;
      print(
          "videofile name----------------------------------------------------------");
      print(fileName);
      print(
          "videofile format-----------------------------------------------------------");
      print(fileName.split('.').last);
      // print(thumnail_image_name.split('.').last);

      firebase_storage.Reference ref = storage.ref(
          'assets/${currentuserid}/videos/${newId.id}/${newId.id}.${fileName.split('.').last}');
      firebase_storage.UploadTask uploadTask = ref.putFile(_videoFile);
      uploading_task = uploadTask; //to pass to loading_screen

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
        videoslist.add(NewVideo(
            titleController.text,
            decsiptionController.text,
            selectedCountry,
            selectedLanguage,
            commentStatus,
            'Public',
            selectedCategory,
            _videoFile));
        print("videos: $videoslist");

        print("hello2");
        print("currentUserChannelDetails");
        //print(channelDetails);
        print(channelDetails.channelName);
        await FirebaseFirestore.instance
            .collection('videos')
            .doc(newId.id)
            .set({
          'category': videoslist[0].category,
          'channelId': channelDetails.id,
          'channelName': channelDetails.channelName,
          'comments': 0,
          'country': videoslist[0]['country'],
          'date': DateTime.now(),
          'description': videoslist[0].description,
          'disLikes': 0,
          'duration': (info.duration / 1000).round(), //calculate
          'generatedThumbnail': thumbnail_url, //generate
          'id': newId.id,
          'isComments': videoslist[0].commentallowed,
          'isVerified': channelDetails.isVerified,
          'isVisible': videoslist[0].visibility,
          'language': selectedLanguage,
          'likes': 0,

          'profilePic': channelDetails.profilePic,
          'shortLink': " ", //to be filled
          'subscribers': channelDetails.subsribers,
          'thumbnail': thumbnail_url,
          'title': videoslist[0].title,
          'updated': DateTime.now(),
          'videoScore': 0,
          'videoSrc': url,
          'views': 0,
        });
        print("hello3");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        _isLoading = false;
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
                    padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                    child: Text(
                      'Upload',
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),

                  //----------------------
                  thumbanil != null
                      ? Container(
                          child: Image.file(
                            thumbanil,
                            fit: BoxFit.fill,
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
                                      'Millions',
                                      style: TextStyle(color: primary),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Upload Post from:'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Gallery'),
                                        onPressed: () {
                                          _fromgallery();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Record a video'),
                                        onPressed: () {
                                          _selectVideo();
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
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.network(
                                          'https://image.flaticon.com/icons/png/512/262/262530.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Upload Video',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.ubuntu(
                                            color: primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                  if (thumbanil != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          //--------------------
                          _thumbnailfromgallery();
                        },
                        style: ElevatedButton.styleFrom(primary: primary),
                        child: Text(
                          'Upload custom thumbnail',
                          style: GoogleFonts.ubuntu(),
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
                          ),
                        ),
                      ),
                      style: GoogleFonts.ubuntu(),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Text(
                      'Video Country',
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
                ],
              ),
            ),
    );
  }
}
