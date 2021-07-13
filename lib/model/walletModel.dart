class Wallet {
  bool isActivated, isBlocked;
  int money;
  String name, profilePic, user;
  Wallet(
      {this.isActivated,
      this.isBlocked,
      this.money,
      this.name,
      this.profilePic,
      this.user});
  factory Wallet.fromDoc(Map map) {
    return Wallet(
        isActivated: map["isActivated"],
        isBlocked: map["isBlocked"],
        money: map["money"],
        name: map["name"],
        profilePic: map["profilePic"],
        user: map["user"]);
  }
}
