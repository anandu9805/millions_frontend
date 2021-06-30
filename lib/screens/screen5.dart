import 'package:flutter/material.dart';
import 'package:millions/widgets/sliver_appbar.dart';
import 'package:millions/widgets/videoCard.dart';
import 'package:millions/model/video.dart';

class Screen5 extends StatefulWidget {
  @override
  _Screen5State createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  @override
   Widget build(BuildContext context) {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    return Scaffold(
        key: _drawerKey,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final video = videos[index];
                  return VideoCard(video: video);
                },
                childCount: videos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
