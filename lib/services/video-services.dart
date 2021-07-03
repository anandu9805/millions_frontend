import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/model/video.dart';

class VideoServices {
  List<Video> videos;
  CollectionReference videosRefernce =
      FirebaseFirestore.instance.collection('videos');

  Future<QuerySnapshot> getAllVideos() {
    // QuerySnapshot res = videosRefernce.get();
    // videos = res.docs.map((doc) => Video.fromMap(doc.data())).toList();
    // return videosRefernce.get();
    // print(res.docs);
    // List<dynamic> data = res.docs;
    // print(data.runtimeType);
    // List<Video> videos = data
    //     .map(
    //       (dynamic item) => Video.fromJson(item),
    //     )
    //     .toList();
    // return res;

    // return res.docs.map((doc) => Video(
    //       category: doc['category'],
    //       channelId: doc['channelId'],
    //       channelName: doc['channelName'],
    //       comments: doc['comments'],
    //       country: doc['country'],
    //       date: doc['date'],
    //       description: doc['description'],
    //       disLikes: doc['disLikes'],
    //       id: doc['id'],
    //       isComments: doc['isComments'],
    //       isVisible: doc['isVisible'],
    //       language: doc['language'],
    //       likes: doc['likes'],
    //       subscribers: doc['subscribers'],
    //       thumbnailUrl: doc['thumbnailUrl'],
    //       title: doc['title'],
    //       videoScore: doc['videoScore'],
    //       videoSrc: doc['videoSrc'],
    //       views: doc['views'],
    //     )).toList();
  }
}

// To parse this JSON data, do
//
//     final videos = videosFromJson(jsonString);
