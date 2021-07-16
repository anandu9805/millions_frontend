import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millions/model/video.dart';

class ReportModel {
  Timestamp lastReported;
  Video video;
  String reason;
  ReportModel({
    this.lastReported,
    this.video,
    this.reason,
  });

  factory ReportModel.fromDoc(Map<String, dynamic> map) {
    return ReportModel(
      lastReported: map["lastReported"],
      video: map["video"],
      reason: map["reason"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lastReported": lastReported,
      "video": video,
      "reason": reason,
    };
  }
}
