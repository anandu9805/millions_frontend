import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  CommentModel({
    this.channel,
    this.channelName,
    this.comment,
    this.commentId,
    this.date,
    this.dislikes,
    this.editedTime,
    this.isOwner,
    this.likes,
    this.name,
    this.profilePic,
    this.replies,
    this.score,
    this.source,
    this.type,
    this.uniqueId,
    this.userId,
    this.videoId,
    this.videoTitle,
  });

  String channel;
  String channelName;
  String comment;
  String commentId;
  Timestamp date;
  int dislikes;
  Timestamp editedTime;
  bool isOwner;
  int likes;
  String name;
  String profilePic;
  int replies;
  int score;
  String source;
  String type;
  String uniqueId;
  String userId;
  String videoId;
  String videoTitle;

  factory CommentModel.fromMap(Map snapshot) {
    // print(snapshot["id"]);
    return CommentModel(
      channel: snapshot["channel"],
      channelName: snapshot["channelName"],
      comment: snapshot["comment"],
      commentId: snapshot["commentId"],
      date: snapshot["date"],
      dislikes: snapshot["dislikes"],
      editedTime: snapshot["editedTime"],
      isOwner: snapshot["isOwner"],
      likes: snapshot["likes"],
      name: snapshot["name"],
      profilePic: snapshot["profilePic"],
      replies: snapshot["replies"],
      score: snapshot["score"],
      source: snapshot["source"],
      type: snapshot["type"],
      uniqueId: snapshot["uniqueId"],
      userId: snapshot["userId"],
      videoId: snapshot["videoId"],
      videoTitle: snapshot["videoTitle"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "channel": channel,
      "channelName": channelName,
      "comment": comment,
      "commentId": commentId,
      "date": date,
      "dislikes": dislikes,
      "editedTime": editedTime,
      "isOwner": isOwner,
      "likes": likes,
      "name": name,
      "profilePic": profilePic,
      "replies": replies,
      "score": score,
      "source": source,
      "type": type,
      "uniqueId": uniqueId,
      "userId": userId,
      "videoId": videoId,
      "videoTitle": videoTitle,
    };
  }
}
