import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
   TextEditingController decsiptionController;
   TextEditingController titleController;
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: IconButton(
                          onPressed: () {
                            print('Iconbutton Pressed');
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 30,
                          ),
                          iconSize: 30,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(200, 0, 0, 0),
                        child: IconButton(
                          onPressed: () {
                            print('IconButtn Pressed');
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 30,
                          ),
                          iconSize: 30,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          width: 35,
                          height: 35,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Color(0xFFF5F5F5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                              child: Image.network(
                                'https://image.flaticon.com/icons/png/512/262/262530.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                              child: Text(
                                'Upload',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.ubuntu(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30,
                                ),
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
                        color: Colors.purple,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
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
                  controller: decsiptionController,
                  obscureText: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
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
            ],
          ),
        ),
      ),
    );
  }
}
