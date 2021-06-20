import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/home.dart';

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  TextEditingController decsiptionController;
  TextEditingController titleController;
  List<String> comments = ['Enabled', 'Disabled'];
  String commentStatus = 'Enabled';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    decsiptionController = TextEditingController();
    titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // children: [
              // IconButton(
              //   onPressed: () {
              //     print('Iconbutton Pressed');
              //   },
              //   icon: Icon(
              //     Icons.arrow_back,
              //     color: Colors.black,
              //     size: 30,
              //   ),
              //   iconSize: 30,
              // ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(200, 0, 0, 0),
              //   child: IconButton(
              //     onPressed: () {
              //       print('IconButtn Pressed');
              //     },
              //     icon: Icon(
              //       Icons.search,
              //       color: Colors.black,
              //       size: 30,
              //     ),
              //     iconSize: 30,
              //   ),
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.1,
              //   height: MediaQuery.of(context).size.width * 0.1,
              //   clipBehavior: Clip.antiAlias,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //   ),
              //   child: Image.network(
              //     'https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg',
              //   ),
              // ),
              // ],
              // ),
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
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                  onTap: () {},
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
                  'Write A Post',
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

              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: primary),
                  child: Text(
                    'Upload',
                    style: GoogleFonts.ubuntu(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
