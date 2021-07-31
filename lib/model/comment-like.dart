class CommentLike {
  CommentLike({
    this.channel,
    this.comment,
    this.commentId,
    this.commentOwner,
    this.date,
    this.follower,
    this.isOwner,
    this.liked,
    this.likerName,
    this.likerPhoto,
    this.type,
    this.video,
    this.videoTitle,
  });
  String channel;
  String comment;
  String commentId;
  String commentOwner;
  DateTime date;
  String follower;
  bool liked;
  bool isOwner;
  String likerName;
  String likerPhoto;
  String type;
  String video;
  String videoTitle;
  factory CommentLike.fromMap(Map snapshot) {
    // print(snapshot["id"]);
    return CommentLike(
        channel: snapshot["channel"],
        comment: snapshot["comment"],
        commentId: snapshot["commentId"],
        commentOwner: snapshot["commentOwner"],
        date: snapshot["date"],
        follower: snapshot["follower"],
        isOwner: snapshot["isOwner"],
        liked: snapshot["liked"],
        likerName: snapshot["likerName"],
        likerPhoto: snapshot["likerPhoto"],
        type: snapshot["type"],
        video: snapshot["video"],
        videoTitle: snapshot["videoTitle"]);
  }
}
