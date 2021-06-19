import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
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
                Container(
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
              ],
            ),
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
                onTap: (){},
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  //margin: const EdgeInsets.all(15.0),
                  //padding: const EdgeInsets.all(3.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: primary)),
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
                                  color:primary,
                                  fontWeight: FontWeight.w600,
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
                onTap: (){},
                child: Container(
                  //margin: const EdgeInsets.all(15.0),
                  //padding: const EdgeInsets.all(3.0),
                  height: MediaQuery.of(context).size.width * 0.5,
                  decoration:
                      BoxDecoration(border: Border.all(color: primary)),
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
                                    print('Iconbutton pressed');
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
          ],
        ),
      ),
    );
  }
}
