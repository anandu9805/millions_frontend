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

  Future<int> videoLikeCount(String videoId) async =>
      await FirebaseFirestore.instance
          .collection('video-likes')
          .where('video', isEqualTo: videoId)
          .where('liked', isEqualTo: true)
          .get()
          .then((value) {
        return value.size;
      });

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

  // Future<bool> reelsLikeChecker(String likeId) async {
  //   bool liked;
  //   FirebaseFirestore.instance
  //       .collection('reels-likes')
  //       .doc(likeId)
  //       .get()
  //       .then((value) {
  //     liked = value.get('liked') || false;
  //     liked = liked ?? false;
  //     return liked;
  //   });
  // }

  Future<DocumentSnapshot> reelsLikeChecker(String likeId) async {
    FirebaseFirestore.instance
        .collection('reels-likes')
        .doc(likeId)
        .get()
        .then((value) {
          if(value.exists){
            print(value.get('liked'));
          }else{
            print(false);
          }
        });
    return await FirebaseFirestore.instance
        .collection('reels-likes')
        .doc(likeId)
        .get();
  }

  likeReels(String reelId, String channelId, String userId) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance
        .collection('reels-likes')
        .doc(userId + '_' + reelId)
        .set(
      {
        'channel': channelId,
        'date': DateTime.now(),
        'follower': userId,
        'liked': true,
        'link': 'reels/' + reelId,
        'source': 'videos',
        'video': reelId
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
