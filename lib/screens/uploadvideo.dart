import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:millions/screens/home.dart';
import '../model/newvideo_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  List videoslist = [];
  File _videoFile;
  bool uploadComplete = false;

  TextEditingController decsiptionController;
  TextEditingController titleController;
  String selectedCountry = 'Choose Your Country';
  List<String> lanuages = ['Malayalam', 'English', 'Hindi'];
  List<String> comments = ['Enabled', 'Disabled'];
  List<String> category = ['All Videos', 'Entertainment', 'Comedy'];
  List<String> visibility = ['Private', 'Public'];
  String selectedLanguage = 'English';
  String commentStatus = 'Enabled';
  String selectedCategory = 'All Videos';
  String selectedVisibility = 'Private';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    decsiptionController = TextEditingController();
    titleController = TextEditingController();
  }
  void _fromgallery() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getVideo(
        source: ImageSource.gallery,
     );

    setState(() {
      _videoFile = File(pickedImageFile.path);

      uploadComplete = true;

    });
  }

  void  _selectVideo() async {
    final _picker = ImagePicker();
    PickedFile pickedImageFile = await _picker.getVideo(
        source: ImageSource.camera,
        );

    setState(() {
      _videoFile= File(pickedImageFile.path);

      uploadComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {print("_videoFile $_videoFile");
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
                'Upload',
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),

            //----------------------
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
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.network(
                            'https://image.flaticon.com/icons/png/512/262/262530.png',
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                        selectedCountry = country.displayName;
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
                  items: lanuages.map((lang) {
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
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Text(
                'Video Visibility',
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
                  value: selectedVisibility,
                  onChanged: (newValue) {
                    setState(() {
                      selectedVisibility = newValue.toString();
                    });
                  },
                  items: visibility.map((visi) {
                    return DropdownMenuItem(
                      child: new Text(
                        visi,
                        style: GoogleFonts.ubuntu(color: Colors.black),
                      ),
                      value: visi,
                    );
                  }).toList(),
                ),
              ),
            ),
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
                  items: category.map((catg) {
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
                  videoslist.add(NewVideo(titleController.text,decsiptionController.text,selectedCountry,selectedLanguage,commentStatus,selectedVisibility,selectedCategory,_videoFile));
                  print("posts: $videoslist");
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
