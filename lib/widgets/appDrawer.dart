import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/noNetConnection.dart';
import 'package:millions/screens/trendingChannels.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultDrawer extends StatefulWidget {
  //const DefaultDrawer({ Key? key }) : super(key: key);

  @override
  _DefaultDrawerState createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                  height: 142,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/million final logo with out millions.png",
                  )),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            ListTile(
              title: Text('Trending Channels'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrendingChannels()),
                );
              },
            ),
            Divider(
              color: primary,
              thickness: 0.5,
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                _launchInBrowser('https://docs.millionsofficial.in/docs/intro');
              },
            ),
            ListTile(
              title: Text('Report Bug'),
              onTap: () {
                _launchInBrowser(
                    'https://docs.millionsofficial.in/docs/bugs/report-bugs');
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {
                _launchInBrowser(
                    'https://docs.millionsofficial.in/docs/privacy/privacy-policy');
              },
            ),
            ListTile(
              title: Text('Terms Of Service'),
              onTap: () {
                _launchInBrowser(
                    'https://docs.millionsofficial.in/docs/privacy/terms');
              },
            ),
            ListTile(
              title: Text('Support'),
              onTap: () {
                _launchInBrowser(
                    'https://docs.millionsofficial.in/docs/bugs/support');
              },
            ),
            // ListTile(
            //   title: Text('No Internet'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => NoInternet()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text('Create Profile'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => CreateProfile()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
