import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/widgets/comments.dart';

class CommentServices {
  List<Comment> videos;
  CollectionReference commentReference =
      FirebaseFirestore.instance.collection('comments');

  Stream<QuerySnapshot> getAllComment() {
    return commentReference.get().asStream();
  }

  Stream<QuerySnapshot> getOneVideoComments(String videoId) {
    return commentReference
        .where('videoId', isEqualTo: videoId)
        .limit(1)
        .get()
        .asStream();
  }

  Stream<QuerySnapshot> getVideoComments(String videoId) {
    return commentReference
        .where('videoId', isEqualTo: videoId)
        .get()
        .asStream();
  }

  commentVideo(String videoId, String channelId, String userId) async {
    await FirebaseFirestore.instance
        .collection('comments')
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

  addVideoComment(
      String channel,
      String channelName,
      String comment,
      String commentId,
      bool isOwner,
      String link,
      String name,
      String profilePic,
      String type,
      String uniqueId,
      String source,
      String userId,
      String videoId,
      String videoTitle) async {
    await FirebaseFirestore.instance.collection('comments').doc(commentId).set(
      {
        "channel": channel,
        "channelName": channelName,
        "comment": comment,
        "commentId": commentId,
        "date": DateTime.now(),
        "dislikes": 0,
        "editedTime": DateTime.now(),
        "isOwner": isOwner,
        "likes": 0,
        "link": link,
        "name": name,
        "profilePic": profilePic,
        "replies": 0,
        "score": 0,
        "source": source,
        "type": type,
        "uniqueId": uniqueId,
        "userId": userId,
        "videoId": videoId,
        "videoTitle": videoTitle,
      },
    );
  }

  addCommentReply(
      String channel,
      String channelName,
      String comment,
      String commentId,
      bool isOwner,
      String link,
      String name,
      String parent,
      String profilePic,
      String source,
      String type,
      String uniqueId,
      String userId,
      String videoId,
      String videoTitle) async {
    await FirebaseFirestore.instance.collection('comments').doc(commentId).set(
      {
        "channel": channel,
        "channelName": channelName,
        "comment": comment,
        "commentId": commentId,
        "date": DateTime.now(),
        "dislikes": 0,
        "editedTime": DateTime.now(),
        "isOwner": isOwner,
        "link": link,
        "likes": 0,
        "name": name,
        "parent": parent,
        "profilePic": profilePic,
        "replies": 0,
        "score": 0,
        "source": source,
        "type": "reply-comment",
        "uniqueId": uniqueId,
        "userId": userId,
        "videoId": videoId,
        "videoTitle": videoTitle,
      },
    );
  }

  likeComment(
      String channel,
      String comment,
      String commentId,
      String commentOwner,
      String follower,
      bool isOwner,
      String likerName,
      String likerPhoto,
      String type,
      String video,
      String videoTitle) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance
        .collection('comment-likes')
        .doc(follower + '_' + commentId)
        .set(
      {
        ' channel': channel,
        ' comment': comment,
        ' commentId': commentId,
        ' commentOwner': commentOwner,
        ' date': DateTime.now(),
        ' follower': follower,
        ' isOwner': isOwner,
        ' liked': true,
        ' likerName': likerName,
        ' likerPhoto': likerPhoto,
        ' type': type,
        ' video': video,
        ' videoTitle': videoTitle
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  dislikeComment(
      String channel,
      String comment,
      String commentId,
      String commentOwner,
      String follower,
      bool isOwner,
      String likerName,
      String likerPhoto,
      String type,
      String video,
      String videoTitle) async {
    // var newId = FirebaseFirestore.instance.collection('reports').doc();
    await FirebaseFirestore.instance
        .collection('comment-likes')
        .doc(follower + '_' + commentId)
        .set(
      {
        ' channel': channel,
        ' comment': comment,
        ' commentId': commentId,
        ' commentOwner': commentOwner,
        ' date': DateTime.now(),
        ' follower': follower,
        ' isOwner': isOwner,
        ' liked': false,
        ' likerName': likerName,
        ' likerPhoto': likerPhoto,
        ' type': type,
        ' video': video,
        ' videoTitle': videoTitle
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<int> getCommentLikeCount(String commentId) async =>
      await FirebaseFirestore.instance
          .collection('comment-likes')
          .where('commentId', isEqualTo: commentId)
          .where('liked', isEqualTo: true)
          .get()
          .then((value) {
        return value.size;
      });

  Future<int> getCommentDisLikeCount(String commentId) async =>
      await FirebaseFirestore.instance
          .collection('comment-likes')
          .where('commentId', isEqualTo: commentId)
          .where('liked', isEqualTo: false)
          .get()
          .then((value) {
        return value.size;
      });

  Future<DocumentSnapshot> commentLikeChecker(String commentLikeId) async {
    // print(likeId);
    return await FirebaseFirestore.instance
        .collection('comment-likes')
        .doc(commentLikeId)
        .get();
  }
}
