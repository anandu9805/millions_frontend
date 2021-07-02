import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/createPost.dart';
import 'package:millions/screens/screen11.dart';
import 'package:millions/screens/screen5.dart';
import 'package:millions/screens/screen9.dart';
import 'package:millions/screens/shorts.dart';
import 'package:millions/screens/view_video.dart';
import 'package:miniplayer/miniplayer.dart';

final selectedVideoProvider = StateProvider<Video>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  static const double _playerMinHeight = 60.0;
  int page = 0;
  final pages = [Screen5(), Shorts(), CreatePage(), Screen9(), Screen11()];

  @override
  initState() {
    super.initState();

  //test-code
   FirebaseFirestore.instance
  .collection('short-ads')
  .get()
  .then((value) => print(value.size));
  //testcode

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       

        body: Consumer(builder: (context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final miniPlayerController =
              watch(miniPlayerControllerProvider).state;
          return Stack(
            children: pages
                .asMap()
                .map((i, screen) => MapEntry(
                      i,
                      Offstage(
                        offstage: page != i,
                        child: screen,
                      ),
                    ))
                .values
                .toList()
                  ..add(
                    Offstage(
                      offstage: selectedVideo == null,
                      child: Miniplayer(
                        controller: miniPlayerController,
                        minHeight: _playerMinHeight,
                        maxHeight: MediaQuery.of(context).size.height,
                        builder: (height, percentage) {
                          if (selectedVideo == null)
                            return const SizedBox.shrink();

                          if (height <= _playerMinHeight + 50.0)
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        selectedVideo.thumbnailUrl,
                                        height: _playerMinHeight - 4.0,
                                        width: 120.0,
                                        fit: BoxFit.cover,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  selectedVideo.title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  selectedVideo.author.username,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          context
                                              .read(selectedVideoProvider)
                                              .state = null;
                                        },
                                      ),
                                    ],
                                  ),
                                  const LinearProgressIndicator(
                                    value: 0.4,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          return VideoScreen();
                        },
                      ),
                    ),
                  ),
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: page,
          // showUnselectedLabels: false,
          backgroundColor: primary,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          onTap: (i) => setState(() => page = i),
          elevation: 0,
          selectedFontSize: 12.0,
          unselectedFontSize: 10.0,
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.white),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_label_outlined),
              activeIcon: Icon(Icons.video_label),
              label: "30s",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Post video"),
            BottomNavigationBarItem(
                backgroundColor: primary,
                icon: Icon(Icons.subscriptions_outlined),
                activeIcon: Icon(Icons.subscriptions),
                label: "Follow"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.photo_outlined,
                ),
                activeIcon: Icon(
                  Icons.photo,
                ),
                label: "Posts"),
          ],
        ),
      ),
    );
  }
}


