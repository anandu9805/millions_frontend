import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/view_video.dart';
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
        title: Text("Video Search", style: GoogleFonts.ubuntu()),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Enter Query", style: GoogleFonts.ubuntu()),
            TextFormField(
              controller: _searchText,
              style: GoogleFonts.ubuntu(),
              cursorColor: primary,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.ubuntu(color: Colors.black),
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: primary),
                  child: Text(
                    "Search",
                    style: GoogleFonts.ubuntu(color: Colors.white),
                  ),
                  onPressed: _search,
                ),
              ],
            ),
            Text(
              _searched ? "Showing results for : " + _searchText.text : '',
              style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 15),
            ),
            Text(
              _searched
                  ? _results.length.toString() +
                      " results found in " +
                      stopwatch.elapsed.inMilliseconds.toString() +
                      "ms"
                  : '',
              style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 12),
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
                      ? Center(
                          child: Text("No results found.",
                              style: GoogleFonts.ubuntu()),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            AlgoliaObjectSnapshot snap = _results[index];
                            //Video video = Video.fromMap(snap.data);
                            // Timestamp time  = snap.data['date'];
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () {
                                  checkExist(snap.data['id']).whenComplete(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewVideo(
                                                video: searchVideo,
                                              )),
                                    );
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 100,
                                          child: Image.network(
                                            
                                              snap.data['thumbnail'] == null
                                                  ? altChannelArt
                                                  : snap.data['thumbnail'],
                                                 loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  //padding: const EdgeInsets.only(top: 20, bottom:20),
                                  //height: MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: primary,
                                      value: loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  ),
                                );
                              },
                                                  
                                                  ),
                                                  ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snap.data['title'],
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(snap.data['channelName'],
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 12)),
                                            // Text(
                                            //    // snap.data['date'].toString() " Views",
                                            //     timeago.format(time.toDate()).toString(),
                                            //     style: GoogleFonts.ubuntu(
                                            //         fontSize: 12))
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
                  Text("Search Powered By  ", style: GoogleFonts.ubuntu()),
                  InkWell(
                    onTap: () {
                      launch(
                          'https://www.algolia.com/?utm_source=react-instantsearch&utm_medium=website&utm_content=millions.vercel.app&utm_campaign=poweredby');
                    },
                    child: Image.asset(
                      'images/algolia.png',
                      scale: 8,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
