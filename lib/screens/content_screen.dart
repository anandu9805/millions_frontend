import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';

import 'package:video_player/video_player.dart';

class ContentScreen extends StatefulWidget {
  final String src;

  const ContentScreen({Key key, this.src}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool _liked = false;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      showControls: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  // height: MediaQuery.of(context).size.height,
  // width: MediaQuery.of(context).size.height,
  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
            _chewieController.videoPlayerController.value.isInitialized
        ? Container(
            color: Colors.black,
            child: Chewie(
              controller: _chewieController,
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: primary,
                ),
                SizedBox(height: 10),
              ],
            ),
          );
    //)
  }
}
