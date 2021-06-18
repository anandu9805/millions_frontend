import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';

class Page8 extends StatefulWidget {
  @override
  _Page8State createState() => _Page8State();
}

class _Page8State extends State<Page8> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                padding: EdgeInsets.fromLTRB(200, 0, 5, 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
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
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://motionarray.imgix.net/preview-75634-8YcoQ8Fyf3_0000.jpg'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2,
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 40, 50, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Leslie Alexander',
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                            
                                              color : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 8, 0, 0),
                                            child: Text(
                                              '5M Followers',
                                              style: GoogleFonts.ubuntu(
                                                  color : Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 8, 0, 0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.3,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1),
                                                  primary: Colors.white),
                                              onPressed: () {
                                                print('Button Pressed');
                                              },
                                              child: Text(
                                                'Follow',
                                                style: GoogleFonts.ubuntu(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'Videos',
                            style: GoogleFonts.ubuntu(
                              color: primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            '30s',
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'Videos Photos',
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                  child: Text(
                    'Recently Uploaded',
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 25, 20),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEE),
                          ),
                          child: Image.network(
                            'https://image.freepik.com/free-vector/organic-flat-abstract-music-youtube-thumbnail_23-2148918556.jpg',
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.8,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              child: Text(
                                'Former Child Actros Who Ended Up Being',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.ubuntu(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: Text(
                                      'Looper',
                                      style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '12 Minutes Ago',
                                    style: GoogleFonts.ubuntu(
                                      color: Color(0xFF464444),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
