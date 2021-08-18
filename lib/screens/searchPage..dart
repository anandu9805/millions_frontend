import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/view_video.dart';
import 'package:numeral/numeral.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  //const SearchPage({ Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<AlgoliaObjectSnapshot> _results;
  Stopwatch stopwatch;
  bool _searching, _searched;
  TextEditingController _searchText;
  Video searchVideo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _results = [];
    _searching = false;
    _searched = false;
    _searchText = TextEditingController(text: "");
  }

  Future<void> checkExist(String docID) async {
    try {
      await FirebaseFirestore.instance.doc("videos/$docID").get().then((doc) {
        setState(() {
          searchVideo = Video.fromMap(doc.data());
        });
      });
    } catch (e) {
      print("Error");
    }
  }

  _search() async {
    setState(() {
      _searching = true;
      _searched = true;
      stopwatch = new Stopwatch()..start();
    });

    Algolia algolia = Algolia.init(
      applicationId: 'FI2RMB1BA3',
      apiKey: 'dc951bf237218cf7a405082de430db51',
    );

    AlgoliaQuery query = algolia.instance.index('videos');
    query = query.query(_searchText.text);
    query = query.facetFilter('isVisible:Public');

    _results = (await query.getObjects()).hits;

    setState(() {
      _searching = false;
      stopwatch.stop();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        // title: Text("Video Search", style: GoogleFonts.ubuntu()),
        title: TextField(
          controller: _searchText,
          style: GoogleFonts.ubuntu(color: Colors.white),
          onSubmitted: (value) {
            _search();
          },
          cursorColor: Colors.white,
          autofocus: true,
          decoration: InputDecoration(
              hintText: " Search",
              border: InputBorder.none,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(12, 15, 12, 12),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Colors.white70,
                onPressed: () {
                  _search();
                },
              )),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: !_searched
              ? <Widget>[
                  Container(
                      // height: MediaQuery.of(context).size.height *
                      //     0.25,

                      child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Image.asset(
                      'images/search_bg.png',
                      width: MediaQuery.of(context).size.width * 0.9,
                      // height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Center(
                        child: Text(
                      "Search Videos",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        color: Colors.grey,
                        // fontWeight: FontWeight.bold
                      ),
                    )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Center(
                        child: Text(
                      "Start Search for Videos by entering a text",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        fontSize: 10,
                        color: Colors.grey,
                        // fontWeight: FontWeight.bold
                      ),
                    )),

                    // Center(
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         primary: primary, elevation: 0),
                    //     onPressed: () {},
                    //     child: Text(
                    //       "View all 30s of your followers",
                    //       style: GoogleFonts.ubuntu(fontSize: 15),
                    //     ),
                    //   ),
                    // )
                  ])),
                ]
              : <Widget>[
                  // Text("Enter Text", style: GoogleFonts.ubuntu()),
                  // TextField(
                  //   controller: _searchText,
                  //   onSubmitted: (value) {
                  //     _search();
                  //   },
                  //   textInputAction: TextInputAction.search,
                  //   style: GoogleFonts.ubuntu(),
                  //   cursorColor: primary,
                  //   decoration: InputDecoration(
                  //     labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: primary,
                  //         width: 1,
                  //       ),
                  //       borderRadius: const BorderRadius.only(
                  //         topLeft: Radius.circular(4.0),
                  //         topRight: Radius.circular(4.0),
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: primary,
                  //         width: 1,
                  //       ),
                  //       borderRadius: const BorderRadius.only(
                  //         topLeft: Radius.circular(4.0),
                  //         topRight: Radius.circular(4.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(primary: primary),
                  //       child: Text(
                  //         "Search",
                  //         style: GoogleFonts.ubuntu(color: Colors.white),
                  //       ),
                  //       onPressed: _search,
                  //     ),
                  //   ],
                  // ),
                  Text(
                    _searched
                        ? "Showing results for : " + _searchText.text
                        : '',
                    style:
                        GoogleFonts.ubuntu(color: Colors.black, fontSize: 15),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: _searching
                        ? Center(
                            child: Text(
                              "Searching, please wait...",
                              style: GoogleFonts.ubuntu(),
                            ),
                          )
                        : _results.length == 0 && _searched
                            ? Container(
                                // height: MediaQuery.of(context).size.height *
                                //     0.25,

                                child: Column(children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                Image.asset(
                                  'images/error_search.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  // height: MediaQuery.of(context).size.height * 0.4,
                                ),
                                Center(
                                    child: Text(
                                  "No Results Found",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    // fontWeight: FontWeight.bold
                                  ),
                                )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Center(
                                    child: Text(
                                  "Try searching another video",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    // fontWeight: FontWeight.bold
                                  ),
                                )),
                              ]))
                            : ListView.builder(
                                itemCount: _results.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  AlgoliaObjectSnapshot snap = _results[index];
                                  //Video video = Video.fromMap(snap.data);
                                  // Timestamp time  = snap.data['date'];
                                  return Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: InkWell(
                                      onTap: () {
                                        checkExist(snap.data['id'])
                                            .whenComplete(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ViewVideo(
                                                    video: searchVideo,
                                                    id: null)),
                                          );
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // border: Border.all(
                                            //   color: Colors.grey,
                                            //   width: 1,
                                            // ),
                                            ),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: ClipRect(
                                                    // clipBehavior: Clip.hardEdge,
                                                    child: Container(
                                                      child: Align(
                                                        alignment: Alignment(
                                                            -0.5, -0.2),
                                                        widthFactor: 1,
                                                        heightFactor: 1,
                                                        child:
                                                            CachedNetworkImage(
                                                          // placeholder: (context, thumbnailUrl) =>
                                                          //     CircularProgressIndicator(),
                                                          imageUrl: snap.data[
                                                                      'thumbnail'] ==
                                                                  null
                                                              ? 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg'
                                                              :
                                                              // "",
                                                              snap.data[
                                                                  'thumbnail'],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "${snap.data['title']}",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.ubuntu(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '${snap.data['channelName']}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.ubuntu(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54,
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
                                  );
                                },
                              ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _searched
                              ? _results.length.toString() +
                                  " results found in " +
                                  stopwatch.elapsed.inMilliseconds.toString() +
                                  "ms"
                              : '',
                          style: GoogleFonts.ubuntu(
                              color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
