import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/model/video.dart';

class VideoServices {
  List<Video> videos;
  CollectionReference videosRefernce =
      FirebaseFirestore.instance.collection('videos');

  Stream<QuerySnapshot> getAllVideos() {
    return FirebaseFirestore.instance.collection('videos').get().asStream();
  }
}

// To parse this JSON data, do
//
//     final videos = videosFromJson(jsonString);
