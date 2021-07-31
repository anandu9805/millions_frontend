import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import '../screens/shorts.dart';
import '../screens/shorts_from_link.dart';
import 'package:millions/model/video.dart';
import 'package:millions/screens/view_video.dart';

import '../screens/screen11.dart';

class DynamicLinkService {
  String type, id;

  Future<void> retrieveDynamicLink(BuildContext context) async {
    print("hello all");
    //  app bought from background to foreground using deeplink
    await FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          _handleDynamicLink(dynamicLink, context);
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
//app opened from link
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDynamicLink(data, context);
  }

  static _handleDynamicLink(
      PendingDynamicLinkData data, BuildContext context) async {
    final Uri deepLink = data?.link;

    if (deepLink == null) {
      return;
    }
    print(deepLink.path);
    print(deepLink.pathSegments);
    print("handling link");
    print(deepLink.queryParameters);
    if (deepLink != null) {
      if (deepLink.queryParameters.containsKey('type')) {
        if (deepLink.queryParameters['type'] == '30s') {
          String reelid = deepLink.queryParameters['id'];

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShortsFromLink(
                reelid: reelid,
              )));
        } else if (deepLink.queryParameters['type'] == 'videos') {
          Video video = null;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ViewVideo(video: video, id: deepLink.queryParameters['id']),
            ),
          );
        } else if (deepLink.queryParameters['type'] == 'posts') {
          // PostDetail photo = null;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Screen11(deepLink.queryParameters['id']),
            ),
          );
        }
      }
    }
  }

  Future<String> createDynamicLink(List arguments) async {
    type = arguments[0];
    id = arguments[1];
    print("type : $type and id : $id");
    //?type=$type/
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://millionsofficial.page.link',
      link: Uri.parse('https://millionsofficial.in/?type=$type&id=$id'),
      androidParameters: AndroidParameters(
        packageName: "com.android.millions",
      ),

      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Millions',
          description: 'Watch Stream Earn Anywhere Anytime',
          imageUrl: Uri.parse(
              "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")
      ),
      // ),
    );
    //var dynamicUrl = await parameters.buildUrl();
    var shortLink = await parameters.buildShortLink();
    var shortUrl = shortLink.shortUrl;
    print(shortUrl.toString());

    return shortUrl.toString();
  }
}