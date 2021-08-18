import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/noNetConnection.dart';
import 'package:millions/screens/trendingChannels.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultDrawer extends StatefulWidget {
  const DefaultDrawer({Key key}) : super(key: key);

  @override
  _DefaultDrawerState createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // key: ,
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
              leading: Icon(Icons.whatshot),
              title: Text('Trending Channels'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrendingChannels()),
                );
              },
            ),
            Divider(
              color: Colors.grey[350],
              thickness: 0.5,
            ),
            ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                subtitle: Text('Get help with Millions'), //

                onTap: () {
                  launch('https://docs.millionsofficial.in/docs/intro');
                }),
            ListTile(
                leading: Icon(Icons.bug_report),
                title: Text('Report Bugs'),
                subtitle: Text('Report bugs directly to us'), //

                onTap: () {
                  launch(
                      'https://docs.millionsofficial.in/docs/privacy/privacy-policy');
                }),
            ListTile(
                leading: Icon(Icons.contact_support),
                title: Text('Support'),
                // subtitle: Text('Get help with Millions'), //

                onTap: () {
                  launch('https://docs.millionsofficial.in/docs/bugs/support');
                }),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Privacy Policy'),
              // subtitle: Text('Get help with Millions'), //

              onTap: () {
                launch(
                    'https://docs.millionsofficial.in/docs/privacy/privacy-policy');
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms of Service'),
              // subtitle: Text('Get help with Millions'), //

              onTap: () {
                launch('https://docs.millionsofficial.in/docs/privacy/terms');
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_page),
              title: Text('Contact Us'),
              // subtitle: Text('Get help with Millions'), //

              onTap: () {
                launch('https://millionsofficial.in/contact-us');
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
