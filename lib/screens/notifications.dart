import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_ago/flutter_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/screen11.dart';
import 'package:millions/screens/view_video.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationPage extends StatefulWidget {
  //const NotificationPage({ Key? key }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<DocumentSnapshot> _notifications = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream;
  bool _loadingNotifications = true,
      _gettingMoreNotifications = false,
      _moreNotificationsAvailable = true;
  ScrollController _notificationScrollController = ScrollController();
  ScrollController _scrollController = ScrollController();
  int _perPage = 10;
  DocumentSnapshot _lastNotification;
  _getNotifications() async {
    Query q = FirebaseFirestore.instance
        .collection("notifications")
        .where("receiver", isEqualTo: altUserId)
        .orderBy("timeStamp", descending: true)
        .limit(_perPage);

    setState(() {
      _loadingNotifications = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _notifications = querySnapshot.docs;
    _lastNotification = querySnapshot.docs[querySnapshot.docs.length - 1];
    //print(_videos);
    setState(() {
      _loadingNotifications = false;
    });
  }

  _getMoreNotifications() async {
    print("Hello from getmorenotif");
    if (!_moreNotificationsAvailable) {
      print("No more notifications");
      return;
    }
    if (_gettingMoreNotifications) {
      return;
    }

    _gettingMoreNotifications = true;
    Query q = FirebaseFirestore.instance
        .collection("notifications")
        .where("receiver", isEqualTo: altUserId)
        .orderBy("timeStamp", descending: true)
        .limit(_perPage)
        .startAfterDocument(_lastNotification);
    QuerySnapshot querySnapshot = await q.get();
    if (querySnapshot.docs.length < _perPage) {
      _moreNotificationsAvailable = false;
    }
    _lastNotification = querySnapshot.docs[querySnapshot.docs.length - 1];
    _notifications.addAll(querySnapshot.docs);
    //print(_videos);

    setState(() {
      _gettingMoreNotifications = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getNotifications();
    _notificationScrollController.addListener(() {
      double maxScroll = _notificationScrollController.position.maxScrollExtent;
      double currentScroll = _notificationScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2;
      //print(delta);

      if (maxScroll - currentScroll < delta) {
        _getMoreNotifications();
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
          "Notifications",
          style: GoogleFonts.ubuntu(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
          controller: _notificationScrollController,
          child: _loadingNotifications
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: primary,
                  )))
              : _notifications.length == 0
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Center(
                          child: Text("No notifications to show!",
                              style: GoogleFonts.ubuntu(fontSize: 15))))
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _notifications.length,
                          controller: _scrollController,
                          itemBuilder: (BuildContext ctx, int index) {
                            String type = _notifications[index]['type'];
                            
                            return InkWell(
                              onTap: () {
                                if (type == "video"|| _notifications[index]['link'].toString().substring(0,6)=="/watch"  || _notifications[index]['link'].toString().substring(0,5)=="watch")
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewVideo(video: null,
                                            id: _notifications[index]['link']
                                                .toString()
                                                .split('/')
                                                .last),
                                      ));

                                      else if(type=="comments")
                                      {
                                         Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Screen11(
                                             _notifications[index]['link']
                                                .toString()
                                                .split('/')
                                                .last),
                                      ));
                                      }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.1,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Row(children: [
                                    Column(children: [
                                      CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        child: ClipRRect(
                                          child: Image.network(
                                            _notifications[index]['photo'] == ""
                                                ? altProfilePic
                                                : _notifications[index]
                                                    ['photo'],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ]),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              _notifications[index]
                                                  ['notification'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ubuntu(),
                                            ),
                                          ),
                                          Text(
                                            FlutterTimeAgo.parse(
                                                _notifications[index]
                                                    ['timeStamp'],
                                                lang: 'en'),
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(type!="follower")  Icon(Icons.keyboard_arrow_right)
                                  ])),
                            );
                          },
                        )
                      ],
                    )),
    );
  }
}
