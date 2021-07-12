import 'dart:io';

class NewReel {
  String title;
  String description;
  String country;
  String language;
  String commentallowed;
  String visibility;
  String category;
  File video;

  NewReel(
      String title,
      String description,
      String country,
      String language,
      String commentallowed,
      String visibility,
      String category,
      File video,
      ) {
    this.title = title;
    this.description = description;
    this.country = country;
    this.language = language;
    this.commentallowed = commentallowed;
    this.visibility = visibility;
    this.category = category;
    this.video = video;
  }
}
