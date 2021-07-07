import 'dart:io';

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
      title;
  int likes, disLikes, postScore, comments;
  bool isVisible;
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
      this.title});

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
    );
  }
}
