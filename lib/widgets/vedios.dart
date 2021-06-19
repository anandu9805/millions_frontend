import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Vedios extends StatefulWidget {


  @override
  _VediosState createState() => _VediosState();
}

class _VediosState extends State<Vedios> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    //_controller = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _controller = VideoPlayerController.asset("images/sample_video.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 200,
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                );
              } else {
                return Center(

                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        ElevatedButton(
          child: Icon(_controller.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow),
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
        ),

      ],
    );
  }
}