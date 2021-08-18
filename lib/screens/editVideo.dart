import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/video.dart';
import 'package:millions/widgets/inputField.dart';

class EditVideo extends StatefulWidget {
  //const EditVideo({ Key? key }) : super(key: key);
  final String myVideoId;
  EditVideo(this.myVideoId);

  @override
  _EditVideoState createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  File thumbnailFile;
  String commentStatus,
      selectedCategory,
      selectedLanguage,
      selectedCountry,
      thumbnailImageName,
      thumbnailUrl;
  bool uploadComplete = false,
      thumbnailChanged = false,
      countrySelected = false,
      _isLoading;
  Video video;
  TextEditingController titleController, descontroller;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> getDetails() async {
    return FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.myVideoId)
        .get()
        .then((value) {
      video = Video.fromMap(value.data());
      commentStatus = video.isComments;
      selectedLanguage = video.language;
      thumbnailUrl = video.thumbnailUrl;
      selectedCategory = video.category;
      selectedCountry = video.country;
      titleController = TextEditingController(text: video.title);
      descontroller = TextEditingController(text: video.description);
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getDetails().whenComplete(() => setState(() {
          _isLoading = false;
        }));
  }

  void _thumbnailFromGallery() async {
    final _picker = ImagePicker();

    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);
    setState(() {
      thumbnailImageName = pickedImageFile.path.split('.').last;
      thumbnailFile = File(pickedImageFile.path);
      thumbnailChanged = true;
    });
  }

  void _thumbnailFromCamera() async {
    final _picker = ImagePicker();

    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);
    setState(() {
      thumbnailImageName = pickedImageFile.path.split('.').last;
      thumbnailFile = File(pickedImageFile.path);
      thumbnailChanged = true;
    });
  }

  Future<void> uploadThumbnail() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    firebase_storage.Reference refThumbnail = storage.ref(
        'assets/$altUserId/videos/${widget.myVideoId}/uploaded-${widget.myVideoId}.$thumbnailImageName');
    firebase_storage.UploadTask uploadThumbnail =
        refThumbnail.putFile(thumbnailFile);
    return uploadThumbnail.whenComplete(() async {
      thumbnailUrl = await refThumbnail.getDownloadURL();
    }).catchError((onError) {
      print(onError);
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

  void updateVideoPost() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (thumbnailChanged) await uploadThumbnail();
      FirebaseFirestore.instance
          .collection('videos')
          .doc(widget.myVideoId)
          .update({
        'isComments': commentStatus,
        'description': descontroller.text,
        'title': titleController.text,
        'language': selectedLanguage,
        'country': selectedCountry,
        'category': selectedCategory,
        'thumbnail': thumbnailChanged ? thumbnailUrl : video.thumbnailUrl,
      }).then((value) {
        _showToast(context, "Video Post Edited Successfully");
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }).catchError((error) =>
              _showToast(context, "Failed to edit video post: $error"));
    } catch (e) {
      print("Error");
    }
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
                          "Edit Video",
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
                          'Video Title',
                          style: GoogleFonts.ubuntu(),
                        ),
                        InputField("", titleController, 4),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Video Description',
                          style: GoogleFonts.ubuntu(),
                        ),
                        InputField("", descontroller, 6),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Language',
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
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.black),
                                  ),
                                  value: lang,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Category',
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
                              value: selectedCategory,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCategory = newValue.toString();
                                });
                              },
                              items: categories.map((categ) {
                                return DropdownMenuItem(
                                  child: new Text(
                                    categ,
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.black),
                                  ),
                                  value: categ,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Video Country',
                          style: GoogleFonts.ubuntu(),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          //width: 20,
                          decoration: BoxDecoration(
                            // color: Colors.transparent,
                            border: Border.all(
                              color: primary,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                countryListTheme: CountryListThemeData(
                                    textStyle: GoogleFonts.ubuntu(),
                                    inputDecoration: InputDecoration(
                                        focusColor: primary,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.grey,
                                        )))),
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country c) {
                                  setState(() {
                                    countrySelected = true;
                                    selectedCountry = c.countryCode;
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Text(
                                countrySelected
                                    ? selectedCountry
                                    : video.country,
                                style: GoogleFonts.ubuntu(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Video Thumbnail',
                          style: GoogleFonts.ubuntu(),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: primary, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "",
                                      style: GoogleFonts.ubuntu(),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showDialog<void>(
                                                context: context,
                                                //barrierDismissible: false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Millions',
                                                      style: GoogleFonts.ubuntu(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: primary),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'Upload Thumbnail Image:',
                                                              style: GoogleFonts
                                                                  .ubuntu()),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          'Select from Gallery',
                                                          style: GoogleFonts
                                                              .ubuntu(
                                                                  color:
                                                                      primary),
                                                        ),
                                                        onPressed: () {
                                                          _thumbnailFromGallery();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'Take a Picture',
                                                          style: GoogleFonts
                                                              .ubuntu(
                                                                  color:
                                                                      primary),
                                                        ),
                                                        onPressed: () {
                                                          _thumbnailFromCamera();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.edit)),
                                      ],
                                    ),
                                  ],
                                ),
                                thumbnailChanged
                                    ? Image.file(thumbnailFile)
                                    : Image.network(video.thumbnailUrl)
                              ],
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
                          updateVideoPost();
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
