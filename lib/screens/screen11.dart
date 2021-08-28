import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/user.dart';
import 'package:millions/widgets/appbar_others.dart';
import 'package:millions/widgets/photos.dart';
import 'package:millions/widgets/appDrawer.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
class Screen11 extends StatefulWidget {
  //---------------------------------------------------------------------------------------------------------------------
  String postId;

  Screen11(String id1) {
    this.postId = id1;
  }

  //---------------------------------------------------------------------------------------------------------------------
  @override
  _Screen11State createState() => _Screen11State();
}

class _Screen11State extends State<Screen11> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  //---------------------------------------------------------------------------------------------------------------------
  PostDetail post2;
  var _isLoading = true;

  _getPostFromId() //to get the post from the id passed through the dynamic link
  async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      post2 = PostDetail.fromMap(documentSnapshot.data());
    });
    setState(() {
      _isLoading = false;
    });
    print(' post2');
    print(post2);
    print(post2.id);
  }

  //---------------------------------------------------------------------------------------------------------------------

  UserDetail user;

  List<DocumentSnapshot> _posts = [];
  bool _loadingPosts = true,
      _gettingMorePosts = false,
      _morePostsAvailable = true;
  int _perPage = 5;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();

  _getPosts() async {
    Query q = FirebaseFirestore.instance
        .collection("posts")
        .where("isVisible", isEqualTo: "Public")
        .orderBy("videoScore", descending: true)
        .limit(_perPage);

    setState(() {
      _loadingPosts = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _posts = querySnapshot.docs;
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    setState(() {
      _loadingPosts = false;
    });
  }

  _getMorePosts() async {
    //print("object called");
    if (!_morePostsAvailable) {
      print("No more posts");
      return;
    }
    if (_gettingMorePosts) {
      return;
    }

    _gettingMorePosts = true;
    Query q = FirebaseFirestore.instance
        .collection("posts")
        .where("isVisible", isEqualTo: "Public")
        .orderBy("videoScore", descending: true)
        .limit(_perPage)
        .startAfterDocument(_lastDocument);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < _perPage) {
      _morePostsAvailable = false;
    }
    _lastDocument = querySnapshot.docs[querySnapshot.size - 1];
    _posts.addAll(querySnapshot.docs);
    //print(_posts.length);

    setState(() {
      _gettingMorePosts = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //---------------------------------------------------------------------------------------------------------------------
    if (widget.postId != null) {
      _getPostFromId();
    }
    //---------------------------------------------------------------------------------------------------------------------
    _getPosts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2;

      if (maxScroll - currentScroll < delta) {
        _getMorePosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _drawerKey,
      drawer: DefaultDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (h) * (1 / 13),
        ),
        child: AppBarOthers(),
      ),
      body: _loadingPosts
          ? Center(
              child: Container(
              child: CircularProgressIndicator(
                color: primary,
              ),
            ))
          : _posts.length == 0
              ? Center(
                  child: Container(
                  child: Text('No posts to show!',
                      style: GoogleFonts.ubuntu(fontSize: 15)),
                ))
              : widget.postId != null
                  ? Column(children: [
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: Photos(post2),
                      ),
                    ])
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 8, bottom: 12),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Posts',
                                style: GoogleFonts.ubuntu(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              )),
                        ),
                        Expanded(
                          child: ScrollWrapper(scrollController: _scrollController,promptAlignment:Alignment.bottomRight ,promptTheme: PromptButtonTheme(color: primary),
                            child: ListView.builder(
                                itemCount: _posts.length,
                                controller: _scrollController,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return Photos(
                                      PostDetail.fromMap(_posts[index].data()));
                                }),
                          ),
                        )
                      ],
                    ),
    );
  }
}
