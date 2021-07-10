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
}
