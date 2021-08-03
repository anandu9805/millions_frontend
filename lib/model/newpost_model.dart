import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewPost {
  String description;
  File image;
  String comment_enabled;

  NewPost(
    String description,
    File image,
    String comment_enabled,
  ) {
    this.description = description;
    this.image = image;
    this.comment_enabled = comment_enabled;
  }
}

class PostDetail {
  String channelId,
      channelName,
      country,
      description,
      id,
      language,
      photoSrc,
      profilePic,
      title,
      isVisible,
      isComments;

  int likes, disLikes, postScore, comments;
  Timestamp date;
  bool isVerified;
  PostDetail(
      {this.channelId,
      this.channelName,
      this.comments,
      this.country,
      this.description,
      this.disLikes,
      this.id,
      this.isVisible,
      this.language,
      this.likes,
      this.photoSrc,
      this.postScore,
      this.profilePic,
      this.isComments,
      this.title,
      this.isVerified,
      this.date});

  factory PostDetail.fromMap(Map snapshot) {
    return PostDetail(
        channelId: snapshot["channelId"],
        channelName: snapshot["channelName"],
        comments: snapshot["comments"],
        country: snapshot["country"],
        description: snapshot["description"],
        disLikes: snapshot["disLikes"],
        id: snapshot["id"],
        isVisible: snapshot["isVisible"],
        language: snapshot["language"],
        likes: snapshot["likes"],
        photoSrc: snapshot["photoSrc"],
        profilePic: snapshot["profilePic"],
        title: snapshot["title"],
        date: snapshot["date"],
        isVerified: snapshot["isVerified"],
        isComments: snapshot["isComments"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "channelId": channelId,
      "channelName": channelName,
      "comments": comments,
      "country": country,
      "description": description,
      "disLikes": disLikes,
      "id": id,
      "isVisible": isVisible,
      "language": language,
      "likes": likes,
      "photoSrc": photoSrc,
      "profilePic": profilePic,
      "title": title,
      "isComments": isComments,
      "date": date,
      "isVerified": isVerified
    };
  }
}
