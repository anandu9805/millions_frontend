// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';

// class User {
//   final String username;
//   final String profileImageUrl;
//   final String subscribers;

//   const User({
//     this.username,
//     this.profileImageUrl,
//     this.subscribers,
//   });
// }

// const User currentUser = User(
//   username: 'Marcus Ng',
//   profileImageUrl:
//       'https://yt3.ggpht.com/ytc/AAUvwniE2k5PgFu9yr4sBVEs9jdpdILdMc7ruiPw59DpS0k=s88-c-k-c0x00ffffff-no-rj',
//   subscribers: '100K',
// );

// Video videoFromJson(String str) => Video.fromJson(json.decode(str));

// String videoToJson(Video data) => json.encode(data.toJson());

import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  Video({
    this.category,
    this.channelId,
    this.channelName,
    this.comments,
    this.country,
    this.date,
    this.description,
    this.disLikes,
    this.duration,
    this.id,
    this.isComments,
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
  dynamic duration;
  String id;
  String isComments;
  String isVisible;
  String language;
  int likes;
  int subscribers;
  String thumbnailUrl;
  String title;
  int videoScore;
  String videoSrc;
  int views;
  String profilePic;

  factory Video.fromMap(Map snapshot) {
    // print(snapshot["id"]);
    return Video(
      category: snapshot["category"],
      channelId: snapshot["channelId"],
      channelName: snapshot["channelName"],
      comments: snapshot["comments"],
      country: snapshot["country"],
      date: snapshot["date"],
      description: snapshot["description"],
      disLikes: snapshot["disLikes"],
      duration: snapshot["duration"],
      id: snapshot["id"],
      isComments: snapshot["isComments"],
      isVisible: snapshot["isVisible"],
      language: snapshot["language"],
      likes: snapshot["likes"],
      profilePic: snapshot["profilePic"],
      subscribers: snapshot["subscribers"],
      thumbnailUrl: snapshot["thumbnail"],
      title: snapshot["title"],
      videoScore: snapshot["videoScore"],
      videoSrc: snapshot["videoSrc"],
      views: snapshot["views"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "channelId": channelId,
      "channelName": channelName,
      "comments": comments,
      "country": country,
      "date": date,
      "description": description,
      "disLikes": disLikes,
      "duration": duration,
      "id": id,
      "isComments": isComments,
      "isVisible": isVisible,
      "language": language,
      "likes": likes,
      "profilePic": profilePic,
      "subscribers": subscribers,
      "thumbnailUrl": thumbnailUrl,
      "title": title,
      "videoScore": videoScore,
      "videoSrc": videoSrc,
      "views": views,
    };
  }
}

// final List<Video> videos = [
//   Video(
//     id: 'x606y4QWrxo',
//     author: currentUser,
//     title: 'Flutter Clubhouse Clone UI Tutorial | Apps From Scratch',
//     thumbnailUrl: 'https://i.ytimg.com/vi/x606y4QWrxo/0.jpg',
//     duration: '8:20',
//     timestamp: DateTime(2021, 3, 20),
//     viewCount: '10K',
//     likes: '958',
//     dislikes: '4',
//   ),
//   Video(
//     author: currentUser,
//     id: 'vrPk6LB9bjo',
//     title:
//         'Build Flutter Apps Fast with Riverpod, Firebase, Hooks, and Freezed Architecture',
//     thumbnailUrl: 'https://i.ytimg.com/vi/vrPk6LB9bjo/0.jpg',
//     duration: '22:06',
//     timestamp: DateTime(2021, 2, 26),
//     viewCount: '8K',
//     likes: '485',
//     dislikes: '8',
//   ),
//   Video(
//     id: 'ilX5hnH8XoI',
//     author: currentUser,
//     title: 'Flutter Instagram Stories',
//     thumbnailUrl: 'https://i.ytimg.com/vi/ilX5hnH8XoI/0.jpg',
//     duration: '10:53',
//     timestamp: DateTime(2020, 7, 12),
//     viewCount: '18K',
//     likes: '1k',
//     dislikes: '4',
//   ),
//   Video(
//     id: 'rJKN_880b-M',
//     author: currentUser,
//     title: 'Flutter Netflix Clone Responsive UI Tutorial | Web and Mobile',
//     thumbnailUrl: 'https://i.ytimg.com/vi/rJKN_880b-M/0.jpg',
//     duration: '1:13:15',
//     timestamp: DateTime(2020, 8, 22),
//     viewCount: '32K',
//     likes: '1.9k',
//     dislikes: '7',
//   ),
// ];

// final List<Video> suggestedVideos = [
//   Video(
//     id: 'rJKN_880b-M',
//     author: currentUser,
//     title: 'Flutter Netflix Clone Responsive UI Tutorial | Web and Mobile',
//     thumbnailUrl: 'https://i.ytimg.com/vi/rJKN_880b-M/0.jpg',
//     duration: '1:13:15',
//     timestamp: DateTime(2020, 8, 22),
//     viewCount: '32K',
//     likes: '1.9k',
//     dislikes: '7',
//   ),
//   Video(
//     id: 'HvLb5gdUfDE',
//     author: currentUser,
//     title: 'Flutter Facebook Clone Responsive UI Tutorial | Web and Mobile',
//     thumbnailUrl: 'https://i.ytimg.com/vi/HvLb5gdUfDE/0.jpg',
//     duration: '1:52:12',
//     timestamp: DateTime(2020, 8, 7),
//     viewCount: '190K',
//     likes: '9.3K',
//     dislikes: '45',
//   ),
//   Video(
//     id: 'h-igXZCCrrc',
//     author: currentUser,
//     title: 'Flutter Chat UI Tutorial | Apps From Scratch',
//     thumbnailUrl: 'https://i.ytimg.com/vi/h-igXZCCrrc/0.jpg',
//     duration: '1:03:58',
//     timestamp: DateTime(2019, 10, 17),
//     viewCount: '358K',
//     likes: '20k',
//     dislikes: '85',
//   ),
// ];
