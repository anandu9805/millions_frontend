import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
                          print('Iconbutton pressed');
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
                          print('Iconbutton pressed');
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
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
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
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFF5F5F5),
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
                              fontWeight: FontWeight.w600,
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
                              color: Colors.purple,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: IconButton(
                              onPressed: () {
                                print('Iconbutton pressed');
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.purple,
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
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFF5F5F5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            '30s\nVideos',
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
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
                              color: Colors.purple,
                            ),
                          ),
                           Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: IconButton(
                        onPressed: () {
                          print('IconBtton Pressed');
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.purple,
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
          ],
        ),
      ),
    );
  }
}
