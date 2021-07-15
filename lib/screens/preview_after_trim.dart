import 'dart:io';

import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:video_player/video_player.dart';
import '../model/content.dart';
import '../screens/uploadreels.dart';

class Preview extends StatefulWidget {
  final String outputVideoPath;File thumbnail;

  Preview(this.outputVideoPath,this.thumbnail);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
   VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print("hello---------------------------------------------------------------------");
    print("File(widget.outputVideoPath!)");
    print(File(widget.outputVideoPath));
    _controller = VideoPlayerController.file(File(widget.outputVideoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor:primary ,
        title: Text("Preview"),actions: [FlatButton(onPressed: (){
       Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => UploadReel(File(widget.outputVideoPath),widget.thumbnail)));
        }, child:Text("Done"))],
      ),

      body: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: _controller.value.isInitialized
              ? Container(
            child: VideoPlayer(_controller),
          )
              : Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
