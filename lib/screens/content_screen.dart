import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';

import 'package:video_player/video_player.dart';
import '../widgets/skeletol_loader.dart';

class ContentScreen extends StatefulWidget {
  final String src;
  final String cover;
  const ContentScreen({Key key, this.src, this.cover}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  VideoPlayerController _videoPlayerController;
  String cover;

  ChewieController _chewieController;
  bool _liked = false;

  @override
  void initState() {
    print("hello we are in content screen");
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src);
    cover = widget.cover;
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      showControls: true,
      looping: true,
      allowFullScreen: false,
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
        : Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            Container(
              color: Colors.black,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: CachedNetworkImage(
                    placeholder: (context, thumbnailUrl) =>
                        SkeletonContainer.square(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    errorWidget: (context, url, error) => SizedBox(width: 16),
                    imageUrl: cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primary,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ]);
  }
}
