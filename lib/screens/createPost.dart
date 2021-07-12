import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/screens/uploadreels.dart';
import 'package:millions/screens/uploadvideo.dart';
import 'package:millions/screens/uploadpost.dart';
import 'package:millions/screens/verification.dart';
import 'package:millions/widgets/appbar_others.dart';
import '../model/reels_model.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                  height: 142,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/million logo with millions.png",
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            ListTile(
              title: Text(
                'Edit Profile',
                style: GoogleFonts.ubuntu(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen14()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Payment Verification',
                style: GoogleFonts.ubuntu(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentVerifcationPage()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Item 3',
                style: GoogleFonts.ubuntu(),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text(
                'Item 4',
                style: GoogleFonts.ubuntu(),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text(
                'Item 5',
                style: GoogleFonts.ubuntu(),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      // appBar: ,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          //  AppBarOthers(),

            Padding(
              padding: EdgeInsets.fromLTRB(35, 30, 0, 20),
              child: Text(
                'Create',
                style: GoogleFonts.ubuntu(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
                  height: MediaQuery.of(context).size.width * 0.5,
                  //margin: const EdgeInsets.all(15.0),
                  //padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(border: Border.all(color: primary)),
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
                                      MaterialPageRoute(builder: (context) => UploadPage()),
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
                  height: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(border: Border.all(color: primary)),
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
                                      MaterialPageRoute(builder: (context) => UploadPost()),
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
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadReel()),//-----------------------------------------------------------
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  //margin: const EdgeInsets.all(15.0),
                  //padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(border: Border.all(color: primary)),
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
                                'Upload\nReels',
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
                                      MaterialPageRoute(builder: (context) => UploadReel()),//-----------------------------------------------------------
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
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
