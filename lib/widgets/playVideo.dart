// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class PlayVideo extends StatefulWidget {
//   final String videoSrc;

//   const PlayVideo({Key key, this.videoSrc}) : super(key: key);

//   @override
//   _PlayVideoState createState() => _PlayVideoState();
// }

// class _PlayVideoState extends State<PlayVideo> {
//   FlickManager flickManager;
//   VideoPlayerController _controller;
//   AspectRatio ratio;
//   @override
//   void initState() {
//     super.initState();
//     // flickManager = FlickManager(
//     //   videoPlayerController:
//     //       VideoPlayerController.network(this.widget.videoSrc),
//     // );
//     _controller = VideoPlayerController.network(this.widget.videoSrc)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : Container(
//                 child: AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//               ),
//         Positioned(
//           bottom: 0,
//           // width: MediaQuery.of(context).size.width*0.1,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.skip_previous_outlined,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 onPressed: () {
//                   _controller.play();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.play_arrow_outlined,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 onPressed: () {
//                   _controller.play();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.pause_outlined,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 onPressed: () {
//                   _controller.play();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.skip_next_outlined,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 onPressed: () {
//                   _controller.seekTo(_controller.position+);
//                 },
//               ),
//               Container(
//                   margin: EdgeInsets.only(right: 3),
//                   width: MediaQuery.of(context).size.width,
//                   child:
//                       VideoProgressIndicator(_controller, allowScrubbing: true))
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millions/model/admodel.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  final String videoSrc;
  const PlayVideo({Key key, this.videoSrc}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PlayVideoState();
  }
}

class _PlayVideoState extends State<PlayVideo> {
  // TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  bool isAdOpen = true;
  dynamic adSrc;

  Future<dynamic> getAdVideo() {
    FirebaseFirestore.instance
        .collection('ads')
        .limit(1)
        .where("showAdIn", whereIn: ["Kollam"])
        .get()
        .then((value) {
          print(value.docs.single['videoSrc']);
          // setState(() {
            adSrc = value.docs.single['videoSrc'];
            print(123);
            print(adSrc);
          // });
        });
    return adSrc;
  }

  @override
  void initState() {
    super.initState();
    Future<String> adSrc = getAdVideo();
    print(adSrc);
    // print(adSrc);
    _videoPlayerController2 =
        VideoPlayerController.network(this.widget.videoSrc);
    _videoPlayerController1 = VideoPlayerController.network("https://firebasestorage.googleapis.com/v0/b/millions-video.appspot.com/o/ads%2Fupload-1622827623432.webm?alt=media&token=5a617958-4ab6-4f1b-b2ac-89ab2c99cf0a");
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: _videoPlayerController1.value.aspectRatio,
      autoPlay: true,
      looping: false,
      showControls: false,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: _chewieController.aspectRatio,
            child: Expanded(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          Positioned(
              right: 0,
              bottom: 0,
              child: isAdOpen
                  ? FlatButton(
                      onPressed: () {
                        setState(() {
                          isAdOpen = false;
                          _chewieController.dispose();
                          _videoPlayerController1.pause();
                          _videoPlayerController1.seekTo(Duration(seconds: 0));
                          _chewieController = ChewieController(
                            videoPlayerController: _videoPlayerController2,
                            aspectRatio:
                                _videoPlayerController2.value.aspectRatio,
                            autoPlay: true,
                            looping: true,
                            autoInitialize: true,
                          );
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "Skip",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Container()),
        ],
      ),
    );
  }
}
