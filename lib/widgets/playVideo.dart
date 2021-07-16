import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  final String videoSrc;

  const PlayVideo({Key key, this.videoSrc}) : super(key: key);

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  FlickManager flickManager;
  VideoPlayerController _controller;
  AspectRatio ratio;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network(this.widget.videoSrc),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlickVideoPlayer(
            flickManager: flickManager,
            // flickVideoWithControls: FlickVideoWithControls(
            //   playerLoadingFallback: Center(
            //     child: CircularProgressIndicator(),
            //   ),
            //   playerErrorFallback: const Center(
            //     child: const Icon(Icons.error, color: Colors.white),
            //   ),
            //   videoFit: BoxFit.cover,
            // ),
          )
        ],
      ),
    );
  }
}
