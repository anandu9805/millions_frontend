import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/screens/home.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/screens/uploadreels.dart';
import 'package:millions/screens/uploadvideo.dart';
import 'package:millions/screens/uploadpost.dart';
import 'package:millions/screens/verification.dart';
import 'package:millions/widgets/appDrawer.dart';
import 'package:millions/widgets/appbar_others.dart';
import '../model/reels_model.dart';
import 'dart:io';

class CreatePage extends StatefulWidget {
  final ChannelModel channel;

  const CreatePage({Key key, this.channel}) : super(key: key);
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  File dummy1 = null, dummy2 = null;
  ChannelModel channel;
  var dummy3;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: DefaultDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (h) * (1 / 13),
        ),
        child: AppBarOthers(),
      ),
      body: SingleChildScrollView(
        child: widget.channel?.accountStatus != "active"
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //  AppBarOthers(),

                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 30),
                      child: Text(
                        'Create',
                        style: GoogleFonts.ubuntu(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UploadPage()),
                        );
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.width * 0.5,
                        //margin: const EdgeInsets.all(15.0),
                        //padding: const EdgeInsets.all(3.0),
                        // decoration:
                        //     BoxDecoration(border: Border.all(color: primary)),
                        child: Card(
                          color: Color(0xffe8e8e8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Upload\nVideo',
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Start',
                                      style: GoogleFonts.ubuntu(
                                        color: primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadPage()),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: primary,
                                          size: 30,
                                        ),
                                        iconSize: 30,
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
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UploadPost()),
                        );
                      },
                      child: Container(
                        //margin: const EdgeInsets.all(15.0),
                        //padding: const EdgeInsets.all(3.0),
                        //height: MediaQuery.of(context).size.width * 0.5,
                        // decoration:
                        //     BoxDecoration(border: Border.all(color: primary)),
                        child: Card(
                          color: Color(0xffe8e8e8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Create \nPost',
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Start',
                                      style: GoogleFonts.ubuntu(
                                        color: primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadPost()),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: primary,
                                          size: 30,
                                        ),
                                        iconSize: 30,
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UploadReel(dummy1, dummy2,
                                  dummy3)), //-----------------------------------------------------------
                        );
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.width * 0.5,
                        //margin: const EdgeInsets.all(15.0),
                        //padding: const EdgeInsets.all(3.0),
                        // decoration:
                        //     BoxDecoration(border: Border.all(color: primary)),
                        child: Card(
                          color: Color(0xffe8e8e8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Upload\n30s',
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Start',
                                      style: GoogleFonts.ubuntu(
                                        color: primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => UploadReel(
                                                    dummy1,
                                                    dummy2,
                                                    dummy3)), //-----------------------------------------------------------
                                          );
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: primary,
                                          size: 30,
                                        ),
                                        iconSize: 30,
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
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              )
            : Container(
                // height: MediaQuery.of(context).size.height *
                //     0.25,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Image.asset(
                    'images/error.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                    // height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Center(
                      child: Text(
                    "Channel Blocked!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.black87,
                      // fontWeight: FontWeight.bold
                    ),
                  )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Center(
                      child: Text(
                    "Your channel is blocked. Contact us if you think this is a mistake",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: 10,
                      color: Colors.grey,
                      // fontWeight: FontWeight.bold
                    ),
                  )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: primary, elevation: 0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text(
                        "Go Home",
                        style: GoogleFonts.ubuntu(fontSize: 15),
                      ),
                    ),
                  )
                ])),
      ),
    );
  }
}
