import 'dart:io';

import './preview_after_trim.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../constants/colors.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

class TrimmerView extends StatefulWidget {
  final File file, thumbnail;

  TrimmerView(this.file, this.thumbnail);
  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
  var info;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  final videoInfo = FlutterVideoInfo();

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  Future<String> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await _trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });
    info = await videoInfo.getVideoInfo(_value);
    print("duration");
    print(info.duration);

    return _value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: primary,
          title: Text("Video Trimmer"),
        ),
        body: Builder(
          builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 30.0, top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Visibility(
                    visible: _progressVisibility,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  FlatButton(
                    color: primary,
                    onPressed: _progressVisibility
                        ? null
                        : () async {
                            _saveVideo().then((outputPath) {
                              print('OUTPUT PATH: $outputPath');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Preview(outputPath,
                                      widget.thumbnail, info.duration),
                                ),
                              );
                            });
                          },
                    child: Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: VideoViewer(trimmer: _trimmer),
                  ),
                  Center(
                    child: TrimEditor(
                      trimmer: _trimmer,
                      viewerHeight: 50.0,
                      viewerWidth: MediaQuery.of(context).size.width,
                      maxVideoLength: Duration(seconds: 30),
                      onChangeStart: (value) {
                        _startValue = value;
                      },
                      onChangeEnd: (value) {
                        _endValue = value;
                      },
                      onChangePlaybackState: (value) {
                        setState(() {
                          _isPlaying = value;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    child: _isPlaying
                        ? Icon(
                            Icons.pause,
                            size: 80.0,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.white,
                          ),
                    onPressed: () async {
                      bool playbackState = await _trimmer.videPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
