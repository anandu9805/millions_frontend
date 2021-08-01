import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  String accountStatus,
      channelArt,
      channelName,
      country,
      description,
      id,
      linkone,
      linktwo,
      profilePic;
  int subsribers, videos;
  bool isVerified;
  Timestamp created;
  ChannelModel(
      {this.accountStatus,
      this.channelArt,
      this.channelName,
      this.country,
      this.description,
      this.id,
      this.linkone,
      this.linktwo,
      this.profilePic,
      this.subsribers,
      this.isVerified,
      this.created,
      this.videos});
  factory ChannelModel.fromDoc(Map<String, dynamic> map) {
    return ChannelModel(
        accountStatus: map["accountStatus"],
        channelArt: map["channelArt"],
        created: map['created'],
        channelName: map["channelName"],
        country: map["country"],
        isVerified: map['isVerified'],
        description: map["description"],
        id: map["id"],
        linkone: map["linkone"],
        linktwo: map["linktwo"],
        profilePic: map["profilePic"],
        subsribers: map["subscribers"],
        videos: map["videos"]);
  }
}


// FutureBuilder<DocumentSnapshot>(
//                                       future: channelDetails,
//                                       builder: (BuildContext context,
//                                           AsyncSnapshot<DocumentSnapshot>
//                                               snapshot) {
//                                         if (snapshot.connectionState ==
//                                             ConnectionState.done) {
//                                           Map<String, dynamic> data =
//                                               snapshot.data.data()
//                                                   as Map<String, dynamic>;
//                                           currentChannel = ChannelModel.fromDoc(data);
//                                           print(currentChannel.channelName);
//                                           return Image.network(
//                                             currentChannel.profilePic,
//                                             //data['profilePic'],
//                                             width: w * 1,
//                                             height: h * 1,
//                                             fit: BoxFit.cover,
//                                           );
//                                         }

//                                         return Image.network(
//                                           propic,
//                                           width: w * 1,
//                                           height: h * 1,
//                                           fit: BoxFit.cover,
//                                         );
//                                       },
//                                     ),