import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/screens/home.dart';
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
  bool profileremoved = false, artremoved = false, profilechanged=false, artchanged=false;
  TextEditingController namecontroller;
  TextEditingController descontroller;
  String message;
  void _fromgallery(int val) async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);
    setState(() {
      if (val == 1) {
        _profileImageFile = File(pickedImageFile.path);
        profilechanged=true;
        profileremoved = false;
      } else {
        _artImageFile = File(pickedImageFile.path);
        artremoved = false;
        artchanged=true;
      }
    });
  }

  Future<void> updateChannel() {
    return FirebaseFirestore.instance
        .collection('channel')
        .doc(widget.myChannel.id)
        .update({
          'name': namecontroller.text,
          'description': descontroller.text,
           
        })
        .then((value) => message = "Channel Updated Successfully")
        .catchError((error) => message = "Failed to update channel: $error");
  }

  void _selectImage(int val) async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);

    setState(() {
      if (val == 1) {
        _profileImageFile = File(pickedImageFile.path);
        profilechanged=true;
        profileremoved = false;
      } else {
        _artImageFile = File(pickedImageFile.path);
        artchanged=true;
        artremoved = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.myChannel.channelName);
    descontroller =
      TextEditingController(text: widget.myChannel.description);
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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 20),
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
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: primary, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Channel Profile Picture",
                                style: GoogleFonts.ubuntu(),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          profileremoved = true;
                                          profilechanged=true;
                                        });
                                      },
                                      icon: Icon(Icons.delete_forever_rounded)),
                                  IconButton(
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          //barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Millions',
                                                style:
                                                    TextStyle(color: primary),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: const <Widget>[
                                                    Text(
                                                        'Upload Profile Picture:'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text(
                                                      'Select from Gallery'),
                                                  onPressed: () {
                                                    _fromgallery(1);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                      'Take a Picture'),
                                                  onPressed: () {
                                                    _selectImage(1);
                                                    Navigator.of(context).pop();
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
                          profilechanged?( profileremoved?Text(
                                  "Profile Picture Removed",
                                  style: GoogleFonts.ubuntu(),
                                ):Image.file(_profileImageFile)):((widget.myChannel.profilePic==null||widget.myChannel.profilePic.isEmpty)?Image.network(altProfilePic):Image.network(widget.myChannel.profilePic))
                          
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  InputField("Channel Name", namecontroller, false),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  InputField("Channel Description", descontroller, false),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: primary, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Channel Art",
                                style: GoogleFonts.ubuntu(),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          artremoved = true;
                                          artchanged=true;
                                        });
                                      },
                                      icon: Icon(Icons.delete_forever_rounded)),
                                  IconButton(
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          //barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Millions',
                                                style:
                                                    TextStyle(color: primary),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: const <Widget>[
                                                    Text('Upload Channel Art:'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text(
                                                      'Select from Gallery'),
                                                  onPressed: () {
                                                    _fromgallery(2);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                      'Take a Picture'),
                                                  onPressed: () {
                                                    _selectImage(2);
                                                    Navigator.of(context).pop();
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
                          artchanged?( artremoved?Text(
                                  "Channel Art Removed",
                                  style: GoogleFonts.ubuntu(),
                                ):Image.file(_artImageFile)):((widget.myChannel.channelArt==null||widget.myChannel.channelArt.isEmpty)?Image.network(altChannelArt):Image.network(widget.myChannel.channelArt))
                          // (artremoved
                          //     ? Text(
                          //         "Channel Art Removed",
                          //         style: GoogleFonts.ubuntu(),
                          //       )
                          //     : (widget.myChannel.channelArt==null||widget.myChannel.channelArt.isEmpty)?Image.network(altChannelArt):((_artImageFile == null)
                          //         ? Image.network(widget.myChannel.channelArt)
                          //         : Image.file(_artImageFile)))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: primary),
                  onPressed: () {
                   // updateChannel();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Millions",
                            style:
                                GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            //message,
                            "Channel Updated Successfully!",
                            style: GoogleFonts.ubuntu(),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                "OK",
                                style: GoogleFonts.ubuntu(color: primary),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePage()));
                              },
                            ),
                          ],
                        );
                      },
                    );
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
