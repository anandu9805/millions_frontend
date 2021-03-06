import 'package:flutter/material.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/view_video.dart';
import 'package:millions/widgets/popUpMenu.dart';
import 'package:numeral/numeral.dart';
import 'package:flutter_time_ago/flutter_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoCard extends StatefulWidget {
  final Video video;
  final int fromwhere;
//1 from home page or explore page or followpage;
  //2 form all other callers
  const VideoCard({Key key, this.video, this.fromwhere}) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  void initState() {
    super.initState();
  }

  static String formatDuration(double time) {
    Duration d = Duration(seconds: time.round());
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    String dummyId = null;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewVideo(video: widget.video, id: dummyId),
          ),
        );
      },
      child: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 9 / 16,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(),
                      //TODO thumbnail
                      child: Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: ClipRect(
                              // clipBehavior: Clip.hardEdge,
                              child: Container(
                                child: Align(
                                  alignment: Alignment(-0.5, -0.2),
                                  widthFactor: 1,
                                  heightFactor: 1,
                                  child: CachedNetworkImage(
                                    // placeholder: (context, thumbnailUrl) =>
                                    //     CircularProgressIndicator(),
                                    imageUrl: widget.video.thumbnailUrl == null
                                        ? 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg'
                                        :
                                        // "",
                                        widget.video?.thumbnailUrl,
                                  ),

                                  // Image.network(
                                  //   widget.video.thumbnailUrl == null
                                  //       ? 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg'
                                  //       :
                                  //       // "",
                                  //       widget.video?.thumbnailUrl,
                                  //   // fit: BoxFit.cover,
                                  //   loadingBuilder: (BuildContext context,
                                  //       Widget child,
                                  //       ImageChunkEvent loadingProgress) {
                                  //     return Center(child: child);
                                  //   },
                                  //   frameBuilder: (BuildContext context,
                                  //       Widget child,
                                  //       int frame,
                                  //       bool wasSynchronouslyLoaded) {
                                  //     return Padding(
                                  //       padding: EdgeInsets.all(0.0),
                                  //       child: child,
                                  //     );
                                  //   },
                                  //   errorBuilder: (context, url, error) =>
                                  //       new Icon(Icons.error),
                                  // ),
                                ),
                              ),
                            )),
                      )),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      color: Colors.black,
                      padding: EdgeInsets.all(2),
                      child: Text(
                        ("${formatDuration(widget.video.duration * 1.0)}"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(//-------------------------------------------------------------------------------------
                          builder: (context) => Page8( widget.video.channelId),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      foregroundImage: NetworkImage(
                          widget.video?.profilePic == null
                              ? altProfilePic
                              : widget.video.profilePic),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "${widget.video.title}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${widget.video.channelName} ??? ${Numeral(widget.video?.views).value()} Views ??? ${FlutterTimeAgo.parse(widget.video?.date.toDate(), lang: 'en')}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //PopUpMenuIcon(""),
                  widget.video.channelId == altUserId && widget.fromwhere == 0
                      ? PopUpMenuIcon("videos", widget.video.id)
                      : Row(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
