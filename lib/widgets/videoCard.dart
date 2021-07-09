import 'package:flutter/material.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/view_video.dart';

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewVideo(
              video: widget.video,
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          children: [

            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(),
                  child: Image.network(
                    widget.video.thumbnailUrl.isEmpty == null ||
                            widget.video.thumbnailUrl == '' ||
                            widget.video.thumbnailUrl.isEmpty
                        ? 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg'
                        : widget.video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, url, error) => new Icon(Icons.error),
                    
                  ),
                ),
              ],
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
