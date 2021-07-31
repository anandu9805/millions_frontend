import 'package:flutter/material.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/view_video.dart';
import 'package:millions/widgets/popUpMenu.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({Key key, this.video}) : super(key: key);

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
            builder: (context) => ViewVideo(
              video: widget.video,
              id:dummyId
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          children: [
            Container(
              height: h * 0.3,
              color: Colors.black,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(),
                    child: Image.network(
                      widget.video.thumbnailUrl == null
                          ? 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg'
                          : widget.video.thumbnailUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        return Center(child: child);
                      },
                      frameBuilder: (BuildContext context, Widget child,
                          int frame, bool wasSynchronouslyLoaded) {
                        return Padding(
                          padding: EdgeInsets.all(0.0),
                          child: child,
                        );
                      },
                      errorBuilder: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 15.0),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${widget.video.channelName}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //PopUpMenuIcon(""),
                  widget.video.channelId == altUserId
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
