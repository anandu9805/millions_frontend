import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/model/channelModel.dart';
import 'package:millions/model/newpost_model.dart';
import 'package:millions/model/reels_model.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/shorts.dart';

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

  reportPost(PostDetail post, String reason) async {
    print(reason);
    print(post.id);
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance.collection('reports').doc(post.id).set(
      {
        'lastReported': DateTime.now(),
        'metaData': post.toJson(),
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

  reportReels(Reels reel, String reason) async {
    print(reason);
    print(reel.id);
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance.collection('reports').doc(reel.id).set(
      {
        'lastReported': DateTime.now(),
        'metaData': reel.toJson(),
        'reasonDetail': FieldValue.arrayUnion([reason]),
        'reportCount': FieldValue.increment(1),
        'reportType': "30s",
        'reportStatus': "Active"
      },
      SetOptions(
        merge: true,
      ),
    );
    print(reason);
  }

  reportChannel(ChannelModel channel, String reason) async {
    print(reason);
    print(channel.id);
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance.collection('reports').doc(channel.id).set(
      {
        'lastReported': DateTime.now(),
        'metaData': channel.toJson(),
        'reasonDetail': FieldValue.arrayUnion([reason]),
        'reportCount': FieldValue.increment(1),
        'reportType': "channel",
        'reportStatus': "Active"
      },
      SetOptions(
        merge: true,
      ),
    );
    print(reason);
  }
}
