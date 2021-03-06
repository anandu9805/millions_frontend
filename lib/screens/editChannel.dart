import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/widgets/inputField.dart';

class EditChannel extends StatefulWidget {
  //const EditChannel({ Key? key }) : super(key: key);
  final ChannelModel myChannel;
  EditChannel(this.myChannel);

  @override
  _EditChannelState createState() => _EditChannelState();
}

class _EditChannelState extends State<EditChannel> {
  File _profileImageFile, _artImageFile;
  bool profileremoved = false,
      artremoved = false,
      profilechanged = false,
      artchanged = false,
      uploadComplete = false,
      _isLoading = false;
  TextEditingController namecontroller,
      descontroller,
      linkOneController,
      linkTwoController;
  String profileFileName, artFileName, channelArtUrl, profileUrl;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  void _fromgallery(int val) async {
    final _picker = ImagePicker();

    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);

    //print(fileName);

    setState(() {
      if (val == 1) {
        profileFileName = pickedImageFile.path.split('/').last;
        _profileImageFile = File(pickedImageFile.path);
        profilechanged = true;
        //profileremoved = false;
      } else {
        artFileName = pickedImageFile.path.split('/').last;
        _artImageFile = File(pickedImageFile.path);
        //artremoved = false;
        artchanged = true;
      }

      uploadComplete = true;
    });
  }

  void _fromCamera(int val) async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);

    // print(fileName);

    setState(() {
      if (val == 1) {
        profileFileName = pickedImageFile.path.split('.').last;
        _profileImageFile = File(pickedImageFile.path);
        profilechanged = true;
        //profileremoved = false;
      } else {
        print(artFileName);
        artFileName = pickedImageFile.path.split('.').last;
        print(artFileName);
        _artImageFile = File(pickedImageFile.path);
        artchanged = true;
        //artremoved = false;
      }
      uploadComplete = true;
    });
  }

  Future<void> uploadProfilePic() async {
    firebase_storage.Reference ref1 =
        storage.ref('assets/$altUserId/channel/$altUserId.$profileFileName');
    firebase_storage.UploadTask profilePicUploadTask =
        ref1.putFile(_profileImageFile);
    return profilePicUploadTask.whenComplete(() async {
      profileUrl = await ref1.getDownloadURL();
      //print(profileUrl);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> uploadChannelArt() async {
    firebase_storage.Reference ref2 =
        storage.ref('assets/$altUserId/channel/banner-$altUserId.$artFileName');
    firebase_storage.UploadTask channelArtUploadTask =
        ref2.putFile(_artImageFile);
    return channelArtUploadTask.whenComplete(() async {
      channelArtUrl = await ref2.getDownloadURL();
      //print(channelArtUrl);
    }).catchError((onError) {
      print(onError);
    });
  }

//-----------------------------------------------------------
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

  void updateChannel() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (artchanged) await uploadChannelArt();
      if (profilechanged) await uploadProfilePic();
      FirebaseFirestore.instance
          .collection('channels')
          .doc(widget.myChannel.id)
          .update({
        'channelName': namecontroller.text,
        'linkone': linkOneController.text,
        'linktwo': linkTwoController.text,
        'description': descontroller.text.isEmpty ? " " : descontroller.text,
        'channelArt': artchanged
            ? channelArtUrl
            : (artremoved ? "" : widget.myChannel.channelArt),
        'profilePic': profilechanged
            ? (profileremoved ? "" : profileUrl)
            : widget.myChannel.profilePic,
      }).then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Page8(widget.myChannel.id)));
        _showToast(context, "Channel Updated Successfully");
      }).catchError((error) =>
              //-------------------------------------------
              _showToast(context, "Failed to update channel: $error"));
    } catch (e) {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    namecontroller = TextEditingController(text: widget.myChannel.channelName);
    descontroller = TextEditingController(text: widget.myChannel.description);
    linkOneController = TextEditingController(text: widget.myChannel.linkone);
    linkTwoController = TextEditingController(text: widget.myChannel.linktwo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                          "Edit Channel",
                          style: GoogleFonts.ubuntu(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Channel Profile Picture",
                                      style: GoogleFonts.ubuntu(),
                                    ),
                                    Row(
                                      children: [
                                        // IconButton(
                                        //     onPressed: () {
                                        //       setState(() {
                                        //         profileremoved = true;
                                        //         //profilechanged=true;
                                        //       });
                                        //     },
                                        //     icon: Icon(
                                        //         Icons.delete_forever_rounded)),
                                        IconButton(
                                            onPressed: () {
                                              showDialog<void>(
                                                context: context,
                                                //barrierDismissible: false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Upload',
                                                      style: GoogleFonts.ubuntu(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: primary),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'It???s recommended to use a picture that???s at least 98 x 98 pixels and 2MB or less.',
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
                                                                        primary)),
                                                        onPressed: () {
                                                          _fromgallery(1);
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
                                                                        primary)),
                                                        onPressed: () {
                                                          _fromCamera(1);
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
                                profilechanged
                                    ? (profileremoved
                                        ? Text(
                                            "Profile Picture Removed",
                                            style: GoogleFonts.ubuntu(),
                                          )
                                        : Image.file(_profileImageFile))
                                    : ((widget.myChannel.profilePic == null ||
                                            widget.myChannel.profilePic.isEmpty)
                                        ? Text(
                                            "No Profile Picture",
                                            style: GoogleFonts.ubuntu(),
                                          )
                                        : Image.network(
                                            widget.myChannel.profilePic))
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "It???s recommended to use a picture that???s at least 98 x 98 pixels and 4MB or less. Use a PNG or GIF (no animations) file. Make sure your picture follows the Millions Community Guidelines.",
                          style: GoogleFonts.ubuntu(fontSize: 7),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InputField("Channel Name", namecontroller, 1),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InputField("Channel Description", descontroller, 4),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InputField("Featured Link 1", linkOneController, 1),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        InputField("Featured Link 2", linkTwoController, 1),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Channel Art",
                                      style: GoogleFonts.ubuntu(),
                                    ),
                                    Row(
                                      children: [
                                        // IconButton(
                                        //     onPressed: () {
                                        //       setState(() {
                                        //         artremoved = true;
                                        //         //artchanged=true;
                                        //       });
                                        //     },
                                        //     icon: Icon(
                                        //         Icons.delete_forever_rounded)),
                                        IconButton(
                                            onPressed: () {
                                              showDialog<void>(
                                                context: context,
                                                //barrierDismissible: false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Upload',
                                                      style: GoogleFonts.ubuntu(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: primary),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'For the best results on all devices, use an image that???s at least 2048 x 1152 pixels and 6MB or less.',
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
                                                                        primary)),
                                                        onPressed: () {
                                                          _fromgallery(2);
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
                                                                        primary)),
                                                        onPressed: () {
                                                          _fromCamera(2);
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
                                artchanged
                                    ? Image.file(_artImageFile)
                                    : (artremoved
                                        ? Text(
                                            "Channel Art Removed",
                                            style: GoogleFonts.ubuntu(),
                                          )
                                        : ((widget.myChannel.channelArt ==
                                                    null ||
                                                widget.myChannel.channelArt
                                                    .isEmpty)
                                            ? Text(
                                                "No Channel Art",
                                                style: GoogleFonts.ubuntu(),
                                              )
                                            : Image.network(
                                                widget.myChannel.channelArt)))
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "For the best results on all devices, use an image that???s at least 2048 x 1152 pixels and 6MB or less.",
                          style: GoogleFonts.ubuntu(fontSize: 7),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: primary),
                        onPressed: () {
                          updateChannel();
                        },
                        child: Text(
                          "Update",
                          style: GoogleFonts.ubuntu(fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                  ]),
                ),
              ),
            ),
    );
  }
}
