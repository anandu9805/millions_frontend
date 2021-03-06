import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/admodel.dart';
import 'package:millions/model/video.dart';
import 'package:video_player/video_player.dart';
import 'package:better_player/better_player.dart';

class PlayVideo extends StatefulWidget {
  final Video video;
  final double duration;
  const PlayVideo({Key key, this.video, this.duration}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PlayVideoState();
  }
}

class _PlayVideoState extends State<PlayVideo> {
  // TargetPlatform _platform;

  BetterPlayerController _betterPlayerController;
  BetterPlayerDataSource _betterPlayerDataSource;

  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  bool isAdOpen = true;
  dynamic adSrc;
  bool _isPlaying = true;
  bool _showSkip = false;
  Duration _duration;
  Duration _position;
  Duration _adPosition;
  bool _isEnd = false;

  Future<dynamic> getAdVideo() {
    FirebaseFirestore.instance
        .collection('ads')
        .limit(1)
        .where("showAdIn", whereIn: ["Kollam", "IN"])
        .get()
        .then((value) {
          print(value.docs.single['videoSrc']);
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
    print(widget.video.duration);
    Future<String> adSrc = getAdVideo();

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: true,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      this.widget.video.videoSrc,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    _betterPlayerController.addEventsListener(_handleEvent);

    print(adSrc);
    // print(adSrc);
    _videoPlayerController2 =
        VideoPlayerController.network(this.widget.video.videoSrc)
          ..addListener(() {
            //   final bool isPlaying = _videoPlayerController2.value.isPlaying;
            //   if (isPlaying != _isPlaying) {
            //     setState(() {
            //       _isPlaying = isPlaying;
            //     });
            //   }
            //   Timer.run(() {
            //     this.setState(() {
            //       _position = _videoPlayerController2.value.position;
            //     });
            //   });
            //   setState(() {
            //     _duration = _videoPlayerController2.value.duration;
            //   });
            //   _duration?.compareTo(_position) == 0 ||
            //           _duration?.compareTo(_position) == -1
            //       ? this.setState(() {
            //           _isEnd = true;
            //         })
            //       : this.setState(() {
            //           _isEnd = false;
            //         });
            // })

            setState(() {
              _position = _videoPlayerController2.value.position;
            });

            if ((_position.inSeconds / widget.video.duration) == 0.7) {
              FirebaseFirestore.instance
                  .collection('views')
                  .doc(altUserId + '_' + widget.video.id)
                  .set(
                {
                  'channel': widget.video.channelId,
                  'itemId': widget.video.id,
                  'percentage': 70,
                  'time': DateTime.now(),
                  'user': altUserId
                },
                SetOptions(
                  merge: true,
                ),
              );
              print((_position.inSeconds / widget.video.duration).toString() +
                  "reached");
              print("update views count");
            }
          })
          ..initialize();
    // _videoPlayerController1 = VideoPlayerController.network(
    //     "https://firebasestorage.googleapis.com/v0/b/millions-video.appspot.com/o/ads%2Fupload-1622827623432.webm?alt=media&token=5a617958-4ab6-4f1b-b2ac-89ab2c99cf0a")
    //   ..addListener(() {
    //     setState(() {
    //       _position = _videoPlayerController1.value.position;
    //     });
    //     print(_position.inSeconds);
    //     if (_position.inSeconds == 10) {
    //       setState(() {
    //         _showSkip = true;
    //       });
    //     }
    //   });
    _chewieController = ChewieController(
      materialProgressColors:
          ChewieProgressColors(playedColor: Color.fromRGBO(255, 255, 0, 0.7)),
      placeholder: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Loading..", style: GoogleFonts.ubuntu()),
          ],
        ),
      ),
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      showControls: false,
      showOptions: false,
      autoInitialize: true,
      allowPlaybackSpeedChanging: false,
    );
  }

  @override
  void dispose() {
    // _videoPlayerController1.dispose();
    // _videoPlayerController2.dispose();
    // _chewieController.dispose();
    _betterPlayerController.removeEventsListener(_handleEvent);
    super.dispose();
  }

  void _handleEvent(BetterPlayerEvent event) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        AspectRatio(
          // aspectRatio: _chewieController.aspectRatio,
          // child: WillPopScope(
          //   onWillPop: () {
          //     if (_chewieController.isPlaying) {
          //       _chewieController.pause();
          //     }
          //     return new Future.value(true);
          //   },
          //   child: Chewie(
          //     controller: _chewieController,
          //   ),
          // ),
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: _betterPlayerController),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: isAdOpen
              ? TextButton(
                  onPressed: () {
                    // setState(() {
                    //   _isPlaying = _videoPlayerController1.value.isPlaying;
                    // });
                    // print(_isPlaying);
                    // if (_isPlaying) {
                    //   setState(() {
                    //     _isPlaying = !_isPlaying;
                    //   });
                    //   _videoPlayerController1.pause();
                    // } else {
                    //   setState(() {
                    //     _isPlaying = !_isPlaying;
                    //   });
                    //   _videoPlayerController1.play();
                    // }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: _isPlaying
                        ? Icon(
                            Icons.pause,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                  ))
              : Container(),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: isAdOpen
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      // isAdOpen = false;
                      // _chewieController.dispose();
                      // _videoPlayerController1.pause();
                      // _videoPlayerController1.seekTo(Duration(seconds: 0));
                      // _chewieController = ChewieController(
                      //   videoPlayerController: _videoPlayerController2,
                      //   aspectRatio: _videoPlayerController2.value.aspectRatio,
                      //   autoPlay: true,
                      //   showOptions: false,
                      //   looping: false,
                      //   allowPlaybackSpeedChanging: true,
                      //   playbackSpeeds: [0.5, 0.75, 1, 1.5, 2],
                      //   autoInitialize: true,
                      // );
                    });
                  },
                  child: _showSkip
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            "Skip",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(),
                )
              : Container(),
        ),
        // Chewie(
        //   controller: _chewieController,
        // ),
      ],
    ));
  }
}
