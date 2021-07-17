import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/model/video.dart';

class UserServices {
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  void getUserDetails(String userId) {
    userReference.doc(userId).get().then((value) => print(value.docs));
  }
}

// To parse this JSON data, do
//
//     final videos = videosFromJson(jsonString);
