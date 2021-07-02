import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; //to use json
import '../constants/colors.dart';
import '../model/newpost_model.dart';

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  List posts = [];
  File _imageFile;

  bool uploadComplete = false;
  TextEditingController decsiptionController;

  List<String> comments = ['Enabled', 'Disabled'];
  String commentStatus = 'Enabled';
  bool allowcomment = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    uploadComplete = false;
    decsiptionController = TextEditingController();
  }

  void _fromgallery() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);

    setState(() {
       _imageFile = File(pickedImageFile.path);

      uploadComplete = true;

    });
  }

  void _selectImage() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 3000,
        maxHeight: 4000);

    setState(() {
      _imageFile = File(pickedImageFile.path);

      uploadComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
              child: Text(
                'Create Post',
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            //-----------

            if(_imageFile != null)
                   Container(
                    child: Image.file(
                _imageFile,
                fit: BoxFit.fill,
              ),

                  ),
            if(_imageFile==null)
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFF5F5F5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Image.network(
                        'https://image.flaticon.com/icons/png/512/262/262530.png',
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Upload An Image',
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
                        posts.add(NewPost(decsiptionController.text, _imageFile,commentStatus));
                        print("posts: $posts");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
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
                      onPressed: () {
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
                                    child: const Text('Take a picture'),
                                    onPressed: () {
                                      _selectImage();
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
