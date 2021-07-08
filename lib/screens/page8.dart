import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/user.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/verification.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/widgets/videoCard.dart';
import '../widgets/photos.dart';

class Page8 extends StatefulWidget {
  String channelId;

  Page8(channelId) {
    this.channelId = channelId;
  }

  @override
  _Page8State createState() => _Page8State();
}

class _Page8State extends State<Page8> {
  String propic =
          'https://resize.indiatvnews.com/en/resize/newbucket/715_-/2021/02/emma-watson-1614303661.jpg',
      username = 'Emma Watson',
      channel;
  int number_of_followers = 0;

  //User user;
  //print(widget.c);

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> userDetails;

  @override
  void initState() {
    channel = widget.channelId;
    userDetails =
        FirebaseFirestore.instance.collection('channels').doc(channel).get();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _drawerKey,
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
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen14()),
                );
              },
            ),
            ListTile(
              title: Text('Payment Verification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentVerifcationPage()),
                );
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          (h) * (1 / 13),
        ),
        child: AppBar(
          leading: Container(
            color: Colors.white,
            width: w / 4,
            child: InkWell(
              child: Image.asset(
                'images/million final logo with out millions.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.centerRight,
              ),
              onTap: () {
                openDrawer();
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: IconButton(
                  icon: Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //go to search screen
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: InkWell(
                child: CircleAvatar(
                  child: ClipRRect(
                    child: Image.network(
                      'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
                      width: w * 0.3,
                      height: w * 0.3,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(w * 0.1),
                  ),
                  // backgroundColor: Colors.black,
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
      ),

      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,
      // key: scaffoldKey,
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 155,
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
                                CircleAvatar(
                                  radius: 40,
                                  child: ClipRRect(
                                    child: FutureBuilder<DocumentSnapshot>(
                                      future: userDetails,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        //---------------------------
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          Map<String, dynamic> data =
                                              snapshot.data.data()
                                                  as Map<String, dynamic>;
                                          return Image.network(
                                            data['profilePic'],
                                            width: w * 1,
                                            height: h * 1,
                                            fit: BoxFit.cover,
                                          );
                                        }
return CircularProgressIndicator();
                                        // return Image.network(
                                        //   propic,
                                        //   width: w * 1,
                                        //   height: h * 1,
                                        //   fit: BoxFit.cover,
                                        // );
                                      },
                                    ),
                                    borderRadius: BorderRadius.circular(w * 1),
                                  ),
                                  // backgroundColor: Colors.black,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 50, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          //---------------------------------------
                                          FutureBuilder<DocumentSnapshot>(
                                            future: userDetails,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                  "Something went wrong",
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }

                                              if (snapshot.hasData &&
                                                  !snapshot.data.exists) {
                                                return Text(
                                                  "User does not exist",
                                                  style: GoogleFonts.ubuntu(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                data = snapshot.data.data()
                                                    as Map<String, dynamic>;

                                                number_of_followers =
                                                    data['subscribers'];
                                                return Text(
                                                  number_of_followers
                                                          .toString() +
                                                      ' Followers',
                                                  style: GoogleFonts.ubuntu(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                );
                                              }

                                              return Text(
                                                "Loading User",
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      // Row(
                                      //   mainAxisSize: MainAxisSize.max,
                                      //   children: [
                                      //     Padding(
                                      //       padding:
                                      //           EdgeInsets.fromLTRB(0, 4, 0, 0),
                                      //       child: Text(
                                      //         number_of_followers.toString()+
                                      //             ' Followers',
                                      //         style: GoogleFonts.ubuntu(
                                      //           color: Colors.white,
                                      //           fontSize: 15,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                print('Button Pressed');
                                              },
                                              child: Text(
                                                'Following',
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
                      SizedBox(
                        width: 20,
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
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'Posts',
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                //   child: Text(
                //     'Recently Uploaded',
                //     style: GoogleFonts.ubuntu(
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                Container(
                  color: Colors.white,
                  height: (h) / 1.9,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("videos")
                        .where('channelId', isEqualTo: channel)
                        .where("isVisible", isEqualTo: "Public")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          //physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          // List<Video> data =
                          //     snapshot.data.docs;
                          // Video data = snapshot.data.doc;
                          children: snapshot.data.docs.map((doc) {
                            Video videoItems = Video.fromMap(doc.data());
                            // print(videoItems.category);

                            // return ListTile(
                            //   title: Text("${videoItems.category}"),

                            // );
                            return VideoCard(
                              video: videoItems,
                            );
                          }).toList(),
                        );
                        // },
                        // scrollDirection: Axis.vertical,
                        // itemCount: snapshot.data.size,
                        // );
                      } else {

                        return Container(
                          child: Center(
                            child:Text('loading')// CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                    // future: VideoServices.getAllVideos(),
                  ),

                  // ListView.builder(
                  //   itemBuilder: (context, index) {
                  //     return Photos(index);
                  //   },
                  //   scrollDirection: Axis.vertical,
                  //   itemCount: 4,
                  // ),

                  /*  Padding(
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
                  ),*/
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}

// class _SearchDemoSearchDelegate extends SearchDelegate<int> {
//   final List<String> _data = ["Item 1", "Item 2","Item 3", "Value 1", "Value 2", "Value 3"];
//      // List<int>.generate(100001, (int i) => i).reversed.toList();
//   final List<String> _history = <String>["Item 1", "Value 2"];

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       tooltip: 'Back',
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//         color: primary,
//       ),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final Iterable<String> suggestions = query.isEmpty
//         ? _history
//         : _data.where((String i) => '$i'.startsWith(query));

//     return _SuggestionList(
//       query: query,
//       suggestions: suggestions.map<String>((String i) => '$i').toList(),
//       onSelected: (String suggestion) {
//         query = suggestion;
//         showResults(context);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final int searched = _data.indexOf(query);
//     if (searched == null || !_data.contains(query)) {
//       return Center(
//         child: Text(
//           'No results found for "$query"\n',
//           style: GoogleFonts.ubuntu(),
//           textAlign: TextAlign.center,
//         ),
//       );
//     }

//     return ListView(
//       children: <Widget>[
//         _ResultCard(
//           title: _data[searched],
//           index: searched,
//           searchDelegate: this,
//         ),
//       ],
//     );
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return <Widget>[
//       query.isEmpty
//           ? IconButton(
//               tooltip: 'Voice Search',

//               icon: const Icon(Icons.mic, color: primary,),
//               onPressed: () {
//                 query = 'TODO: implement voice input';
//               },
//             )
//           : IconButton(
//               tooltip: 'Clear',
//               icon: const Icon(Icons.clear, color: primary,),
//               onPressed: () {
//                 query = '';
//                 showSuggestions(context);
//               },
//             ),
//     ];
//   }
// }

// class _ResultCard extends StatelessWidget {
//   const _ResultCard({this.index, this.title, this.searchDelegate});

//   final int index;
//   final String title;
//   final SearchDelegate<int> searchDelegate;

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return GestureDetector(
//       onTap: () {
//         searchDelegate.close(context, index);
//       },
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: <Widget>[
//               Text(title, style: GoogleFonts.ubuntu(),),
//               Text(
//                 '$index',
//                 style: GoogleFonts.ubuntu( textStyle: theme.textTheme.headline.copyWith(fontSize: 72.0)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SuggestionList extends StatelessWidget {
//   const _SuggestionList({this.suggestions, this.query, this.onSelected});

//   final List<String> suggestions;
//   final String query;
//   final ValueChanged<String> onSelected;

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (BuildContext context, int i) {
//         final String suggestion = suggestions[i];
//         return ListTile(
//           leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
//           title: RichText(
//             text: TextSpan(
//               text: suggestion.substring(0, query.length),
//               style:
//                  GoogleFonts.ubuntu(textStyle: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: suggestion.substring(query.length),
//                   style: GoogleFonts.ubuntu(textStyle: theme.textTheme.subhead),
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             onSelected(suggestion);
//           },
//         );
//       },
//     );
//   }
// }
