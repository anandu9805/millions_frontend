class Comment_Model {

  int id;
  String url;
  String name;
  String comment_text;
  String time;
  String likes_number;
  bool liked;


  Comment_Model(

      int id,
      String url,
      String name,
  String comment_text,
  String time,
  String likes_number,
  bool liked

      ) {

    this.id=id;
    this.url=url;
    this.name=name;
    this.comment_text=comment_text;
    this.time=time;
    this.likes_number=likes_number;
    this.liked=liked;



  }
}
