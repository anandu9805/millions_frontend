import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';



// Video videoFromJson(String str) => Video.fromJson(json.decode(str));

// String videoToJson(Video data) => json.encode(data.toJson());

class Reels {
  Reels({
    this.category,
    this.channelId,
    this.channelName,
    this.comments,
    this.country,
    this.date,
    this.description,
    this.disLikes,
    this.duration,
    this.generatedThumbnail,
    this.id,
    this.isComments,
    this.isVerified,
    this.isVisible,
    this.language,
    this.likes,
    this.profilePic,
    this.subscribers,
    this.thumbnailUrl,
    this.title,
    this.videoScore,
    this.videoSrc,
    this.views,
  });

  String category;
  String channelId;
  String channelName;
  int comments;
  String country;
  Timestamp date;
  String description;
  int disLikes;
  int duration;
  String generatedThumbnail;
  String id;

  String isComments;
  bool isVerified;
  String isVisible;
  String language;
  int likes;
 String profilePic;
  int subscribers;
  String thumbnailUrl;
  String title;
  int videoScore;
  String videoSrc;
  int views;

  factory Reels.fromMap(Map snapshot) {
    // print(snapshot["id"]);
    return Reels(
      category: snapshot["category"],
      channelId: snapshot["channelId"],
      channelName: snapshot["channelName"],
      comments: snapshot["comments"],
      country: snapshot["country"],
      date: snapshot["date"],
      description: snapshot["description"],
      disLikes: snapshot["disLikes"],
      duration: snapshot["duration"],
      generatedThumbnail: snapshot["generatedThumbnail"],
      id: snapshot["id"],
      isComments: snapshot["isComments"],
      isVerified:snapshot["isVerified"],
      isVisible: snapshot["isVisible"],
      language: snapshot["language"],
      likes: snapshot["likes"],
      profilePic:snapshot["profilePic"],
      subscribers: snapshot["subscribers"],
      thumbnailUrl: snapshot["thumbnail"],
      title: snapshot["title"],
      videoScore: snapshot["videoScore"],
      videoSrc: snapshot["videoSrc"],
      views: snapshot["views"],
    );
  }

  // Map<String, dynamic>
  toJson() {
    return {
      "category": category,
      "channelId": channelId,
      "channelName": channelName,
      "comments": comments,
      "country": country,
      "date": date,
      "description": description,
      "disLikes": disLikes,
      "duration":duration,
      " generatedThumbnail": generatedThumbnail,
      "id": id,
      "isComments": isComments,
      "isVerified":isVerified,
      "isVisible": isVisible,
      "language": language,
      "likes": likes,
      "profilePic":profilePic,
      "subscribers": subscribers,
      "thumbnailUrl": thumbnailUrl,
      "title": title,
      "videoScore": videoScore,
      "videoSrc": videoSrc,
      "views": views,
    };
  }
}

