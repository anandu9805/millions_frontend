class ReelsLike {
  ReelsLike({
    this.channel,
    this.date,
    this.follower,
    this.liked,
    this.link,
    this.source,
    this.video,
  });
  String channel;
  DateTime date;
  String follower;
  bool liked;
  String link;
  String source;
  String video;
  factory ReelsLike.fromDoc(Map<String, dynamic> map) {
    // print(snapshot["id"]);
    return ReelsLike(
        channel: map["channel"],
        date: map["date"],
        follower: map["follower"],
        liked: map["liked"],
        link: map["link"],
        source: map["source"],
        video: map["video"]);
  }
  
   factory ReelsLike.fromMap(Map snapshot) {
    // print(snapshot["id"]);
    return ReelsLike(
        channel: snapshot["channel"],
        date: snapshot["date"],
        follower: snapshot["follower"],
        liked: snapshot["liked"],
        link: snapshot["link"],
        source: snapshot["source"],
        video: snapshot["video"]);
  }
}
