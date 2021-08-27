class UserDetail {
  UserDetail(
      {this.accountStatus,
      this.country,
      this.district,
      this.email,
      this.gender,
      this.isVerififed,
      this.language,
      this.name,
      this.phone,
      this.profilePic,
      this.state,
      this.uid});

  String accountStatus,
      country,
      district,
      email,
      gender,
      name,
      phone,
      profilePic,
      state,
      uid;
  bool isVerififed;
  List<dynamic> language;



  factory UserDetail.fromDoc(Map<String, dynamic> map){
    return UserDetail(
      accountStatus: map["accountStatus"],
      country: map["country"],
      district: map["district"],
      email: map["email"],
      gender: map["gender"],
      isVerififed: map["isVerififed"],
      language: map["language"],
      name: map["name"],
      phone: map["phone"],
      profilePic: map["profilePic"].toString(),
      state: map["state"],
      uid: map["uid"]
    );

  }

}