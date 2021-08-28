import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/widgets/photos.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
class Explore extends StatefulWidget {
  const Explore({Key key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<DocumentSnapshot> _videos = [];
  List<DocumentSnapshot> _photos = [];
  bool _loadingVideos = true,
      _gettingMoreVideos = false,
      _moreVideosAvailable = true;
  bool _loadingPhotos = true,
      _gettingMorePhotos = false,
      _morePhotosAvailable = true;
  int _perPage = 10;
  DocumentSnapshot _lastVideo, _lastPhoto;
  ScrollController _photoScrollController = ScrollController();
  ScrollController _videoScrollController = ScrollController();
    ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  _getVideos() async {
    Query q = FirebaseFirestore.instance
        .collection("videos")
        .where("isVisible", isEqualTo: "Public")
        .orderBy("date", descending: true)
        .limit(_perPage);

    setState(() {
      _loadingVideos = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _videos = querySnapshot.docs;
    _lastVideo = querySnapshot.docs[querySnapshot.docs.length - 1];
    //print(_videos);
    setState(() {
      _loadingVideos = false;
    });
  }

  _getMoreVideos() async {
    print("Hello from getmorevideos");
    if (!_moreVideosAvailable) {
      print("No more videos");
      return;
    }
    if (_gettingMoreVideos) {
      return;
    }

    _gettingMoreVideos = true;
    Query q = FirebaseFirestore.instance
        .collection("videos")
        .where("isVisible", isEqualTo: "Public")
        .orderBy("date", descending: true)
        .limit(_perPage)
        .startAfterDocument(_lastVideo);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < _perPage) {
      _moreVideosAvailable = false;
    }
    _lastVideo = querySnapshot.docs[querySnapshot.docs.length - 1];
    _videos.addAll(querySnapshot.docs);
    //print(_videos);

    setState(() {
      _gettingMoreVideos = false;
    });
  }

  _getPhotos() async {
    Query q = FirebaseFirestore.instance
        .collection("posts")
        .where("isVisible", isEqualTo: "Public")
        .orderBy("date", descending: true)
        .limit(_perPage);

    setState(() {
      _loadingPhotos = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _photos = querySnapshot.docs;
    _lastPhoto = querySnapshot.docs[querySnapshot.docs.length - 1];
    //print(_photos);
    setState(() {
      _loadingPhotos = false;
    });
  }

  _getMorePhotos() async {
    print("Hello from getmorephotos");
    if (!_morePhotosAvailable) {
      print("No more photos");
      return;
    }
    if (_gettingMorePhotos) {
      return;
    }

    _gettingMorePhotos = true;
    Query q = FirebaseFirestore.instance
        .collection("posts")
        .where("isVisible", isEqualTo: "Public")
        .orderBy("date", descending: true)
        .limit(_perPage)
        .startAfterDocument(_lastPhoto);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < _perPage) {
      _morePhotosAvailable = false;
    }
    _lastPhoto = querySnapshot.docs[querySnapshot.docs.length - 1];
    _photos.addAll(querySnapshot.docs);
    //print(_photos);

    setState(() {
      _gettingMorePhotos = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getVideos();
    _getPhotos();
    _videoScrollController.addListener(() {
      double maxScroll = _videoScrollController.position.maxScrollExtent;
      double currentScroll = _videoScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2;
      //print(delta);

      if (maxScroll - currentScroll < delta) {
        _getMoreVideos();
      }
    });
    _photoScrollController.addListener(() {
      double maxScroll = _photoScrollController.position.maxScrollExtent;
      double currentScroll = _photoScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2;
      //print(delta);

      if (maxScroll - currentScroll < delta) {
        _getMorePhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Explore",
          style: GoogleFonts.ubuntu(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 50,
              child: AppBar(
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: primary,
                  tabs: [
                    Tab(
                      child: Text('Videos',
                          style: GoogleFonts.ubuntu(color: Colors.black)),
                    ),
                    Tab(
                      child: Text('Posts',
                          style: GoogleFonts.ubuntu(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              children: [
                ScrollWrapper(scrollController: _videoScrollController,promptAlignment:Alignment.bottomRight ,promptTheme: PromptButtonTheme(color: primary),
                  child: SingleChildScrollView(
                      controller: _videoScrollController,
                      child: _loadingVideos
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: primary,
                              )))
                          : _videos.length == 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                      child: Text("No videos to show!",
                                          style:
                                              GoogleFonts.ubuntu(fontSize: 15))))
                              : Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _videos.length,
                                      controller: _scrollController1,
                                      itemBuilder: (BuildContext ctx, int index) {
                                        return VideoCard(
                                            video: Video.fromMap(
                                                _videos[index].data()),fromwhere: 1,);
                                      },
                                    )
                                  ],
                                )),
                ),

                // second tab bar viiew widget
                ScrollWrapper(
                  scrollController: _photoScrollController,promptAlignment:Alignment.bottomRight ,promptTheme: PromptButtonTheme(color: primary),
                  child: SingleChildScrollView(
                      controller: _photoScrollController,
                      child: _loadingPhotos
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: primary,
                              )))
                          : _photos.length == 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                      child: Text("No posts to show!",
                                          style:
                                              GoogleFonts.ubuntu(fontSize: 15))))
                              : Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _photos.length,
                                      controller: _scrollController2,
                                      itemBuilder: (BuildContext ctx, int index) {
                                        return Photos(PostDetail.fromMap(
                                            _photos[index].data()));
                                      },
                                    )
                                  ],
                                )),
                ),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}