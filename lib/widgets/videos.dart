import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
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
          width: MediaQuery.of(context).size.width,
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
          child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
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


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:millions/model/video.dart';
// import 'package:millions/screens/home.dart';
// import 'package:millions/screens/view_video.dart';
// import 'package:miniplayer/miniplayer.dart';

// final selectedVideoProvider = StateProvider<Video>((ref) => null);

// final miniPlayerControllerProvider =
//     StateProvider.autoDispose<MiniplayerController>(
//   (ref) => MiniplayerController(),
// );

// class NavScreen extends StatefulWidget {
//   @override
//   _NavScreenState createState() => _NavScreenState();
// }

// class _NavScreenState extends State<NavScreen> {
//   static const double _playerMinHeight = 60.0;

//   int _selectedIndex = 0;

//   final _screens = [
//     HomePage(),
//     const Scaffold(body: Center(child: Text('Explore'))),
//     const Scaffold(body: Center(child: Text('Add'))),
//     const Scaffold(body: Center(child: Text('Subscriptions'))),
//     const Scaffold(body: Center(child: Text('Library'))),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer(
//         builder: (context, watch, _) {
//           final selectedVideo = watch(selectedVideoProvider).state;
//           final miniPlayerController =
//               watch(miniPlayerControllerProvider).state;
//           return Stack(
//             children: _screens
//                 .asMap()
//                 .map((i, screen) => MapEntry(
//                       i,
//                       Offstage(
//                         offstage: _selectedIndex != i,
//                         child: screen,
//                       ),
//                     ))
//                 .values
//                 .toList()
//                   ..add(
//                     Offstage(
//                       offstage: selectedVideo == null,
//                       child: Miniplayer(
//                         controller: miniPlayerController,
//                         minHeight: _playerMinHeight,
//                         maxHeight: MediaQuery.of(context).size.height,
//                         builder: (height, percentage) {
//                           if (selectedVideo == null)
//                             return const SizedBox.shrink();

//                           if (height <= _playerMinHeight + 50.0)
//                             return Container(
//                               color: Theme.of(context).scaffoldBackgroundColor,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Image.network(
//                                         selectedVideo.thumbnailUrl,
//                                         height: _playerMinHeight - 4.0,
//                                         width: 120.0,
//                                         fit: BoxFit.cover,
//                                       ),
//                                       Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Flexible(
//                                                 child: Text(
//                                                   selectedVideo.title,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .caption
//                                                       .copyWith(
//                                                         color: Colors.white,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: Text(
//                                                   selectedVideo.author.username,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .caption
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w500),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(Icons.play_arrow),
//                                         onPressed: () {},
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(Icons.close),
//                                         onPressed: () {
//                                           context
//                                               .read(selectedVideoProvider)
//                                               .state = null;
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   const LinearProgressIndicator(
//                                     value: 0.4,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           return ViewVideo();
//                         },
//                       ),
//                     ),
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }
