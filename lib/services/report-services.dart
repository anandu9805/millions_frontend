import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/model/video.dart';

class ReportServices {
  reportVideo(Video video, String reason) async {
    print(reason);
    print(video.id);
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance.collection('reports').doc(video.id).set(
      {
        'lastReported': DateTime.now(),
        'metaData': video.toJson(),
        'reasonDetail': FieldValue.arrayUnion([reason]),
        'reportCount': FieldValue.increment(1),
        'reportType': "videos",
        'reportStatus': "Active"
      },
      SetOptions(
        merge: true,
      ),
    );
    print(reason);
  }

  reportPost(Video video, String reason) async {
    print(reason);
    print(video.id);
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance.collection('reports').doc(video.id).set(
      {
        'lastReported': DateTime.now(),
        'metaData': video.toJson(),
        'reasonDetail': FieldValue.arrayUnion([reason]),
        'reportCount': FieldValue.increment(1),
        'reportType': "posts",
        'reportStatus': "Active"
      },
      SetOptions(
        merge: true,
      ),
    );
    print(reason);
  }

}
