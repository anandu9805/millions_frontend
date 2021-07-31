class AdPostModel {
  String adCategory,
      adLink,
      category,
      channelId,
      channelName,
      country,
      description,
      generatedThumbnail,
      id,
      isComments,language,
      photoSrc,
      publishedBy,
      showAdIn,
      thumbnail;
      int views, subsribers, postScore,comments, likes, disLikes;
      bool isVisible;
  AdPostModel(
      {this.adCategory,
      this.disLikes,
      this.isVisible,
      this.language,
      this.likes,
      this.postScore,
      this.adLink,
      this.category,
      this.channelId,
      this.channelName,
      this.comments,
      this.country,
      this.description,
      this.generatedThumbnail,
      this.id,
      this.isComments,
      this.photoSrc,
      this.publishedBy,
      this.showAdIn,
      this.subsribers,
      this.thumbnail,
      this.views});

  factory AdPostModel.fromDoc(Map<String, dynamic> map) {
    return AdPostModel(
        adCategory: map["adCategory"],
        adLink: map["adlink"],
        category: map["category"],
        channelId: map["channelId"],
        channelName: map["channelName"],
        likes: map["likes"],
        disLikes: map["disLikes"],
        language: map["language"],
        postScore: map["postScore"],
        isVisible: map["isVisible"],
        comments: map["comments"],
        country: map["country"],
        description: map["description"],
        generatedThumbnail: map["generatedThumbnail"],
        id: map["id"],
        isComments: map["isComments"],
        photoSrc: map["photoSrc"],
        publishedBy: map["publishedBy"],
        showAdIn: map["showAdIn"],
        subsribers: map["subsribers"],
        thumbnail: map["thumbnail"],
        views: map["views"]);
  }



  
}


