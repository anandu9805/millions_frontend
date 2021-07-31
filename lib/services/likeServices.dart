import 'package:cloud_firestore/cloud_firestore.dart';

class LikeServices {
  Future<DocumentSnapshot> likeChecker(String likeId) async {
    // print(likeId);
    return await FirebaseFirestore.instance
        .collection('video-likes')
        .doc(likeId)
        .get();
  }

  likeVideo(String videoId, String channelId, String userId) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance
        .collection('video-likes')
        .doc(userId + '_' + videoId)
        .set(
      {
        'channel': channelId,
        'date': DateTime.now(),
        'follower': userId,
        'liked': true,
        'link': 'watch/' + videoId,
        'source': 'videos',
        'video': videoId
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  unLikeVideo(String videoId, String channelId, String userId) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    // print(userId + '_' + videoId);
    await FirebaseFirestore.instance
        .collection('video-likes')
        .doc(userId + '_' + videoId)
        .set(
      {
        'channel': channelId,
        'date': DateTime.now(),
        'follower': userId,
        'liked': false,
        'link': "watch/" + videoId,
        'source': "videos",
        'video': videoId
      },
      SetOptions(
        merge: true,
      ),
    );
  }


  Future<DocumentSnapshot> reelsLikeChecker(String likeId) async {
    // print(likeId);
    return await FirebaseFirestore.instance
        .collection('reels-likes')
        .doc(likeId)
        .get();
  }

  likeReels(String videoId, String channelId, String userId) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance
        .collection('reels-likes')
        .doc(userId + '_' + videoId)
        .set(
      {
        'channel': channelId,
        'date': DateTime.now(),
        'follower': userId,
        'liked': true,
        'link': 'reels/' + videoId,
        'source': 'videos',
        'video': videoId
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  unLikeReels(String videoId, String channelId, String userId) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    // print(userId + '_' + videoId);
    await FirebaseFirestore.instance
        .collection('reels-likes')
        .doc(userId + '_' + videoId)
        .set(
      {
        'channel': channelId,
        'date': DateTime.now(),
        'follower': userId,
        'liked': false,
        'link': "reels/" + videoId,
        'source': "videos",
        'video': videoId
      },
      SetOptions(
        merge: true,
      ),
    );
  }


  Future<DocumentSnapshot> postLikeChecker(String likeId) async {
    // print(likeId);
    return await FirebaseFirestore.instance
        .collection('video-likes')
        .doc(likeId)
        .get();
  }

  likePost(String postId, String channelId, String userId) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance
        .collection('video-likes')
        .doc(userId + '_' + postId)
        .set(
      {
        'channel': channelId,
        'date': DateTime.now(),
        'follower': userId,
        'liked': true,
        'link': 'posts/' + postId,
        'source': 'posts',
        'video': postId
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  unLikePost(String postId, String channelId, String userId) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    // print(userId + '_' + postId);
    await FirebaseFirestore.instance
        .collection('video-likes')
        .doc(userId + '_' + postId)
        .set(
      {
        'channel': channelId,
        'date': DateTime.now(),
        'follower': userId,
        'liked': false,
        'link': "posts/" + postId,
        'source': "posts",
        'video': postId
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}
