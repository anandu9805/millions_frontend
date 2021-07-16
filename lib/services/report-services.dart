import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/model/video.dart';

class ReportServices {
  reportVideo(Video video, String reason) async {
    print(reason);
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance.collection('reports').doc(video.id).set(
      {
        'lastReported': DateTime.now(),
        'metaData': video.toJson(),
        'reason': FieldValue.arrayUnion([reason]),
        'reportCount': FieldValue.increment(1)
      },
      SetOptions(
        merge: true,
      ),
    );
    print(reason);
  }
}
