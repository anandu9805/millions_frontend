
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Future<String> getUserDetails(String userId) async =>
      await userReference.doc(userId).get().then(
        (value) {
          return value.get('profilePic');
        },
      );
}

// To parse this JSON data, do
//
//     final videos = videosFromJson(jsonString);
