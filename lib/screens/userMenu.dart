import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/size.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/googleSignIn.dart';
import 'package:millions/screens/myWallet.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/screen14.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
                ),
                title: Text('My Account'),
                subtitle: Text('Edit Name, Phone Number, Languages etc'), //
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Screen14()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_ind),
                title: Text('My Channel'),
                subtitle: Text('View and Manage your content, Channel'), //
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page8(altUserId)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('My Wallet'),
                subtitle: Text('View and Manage your wallet'), //
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyWallet()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                subtitle: Text('Logout or switch accounts'), //
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GoogleSignIn()),
                  );
                },
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.3,
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Help'),
                  subtitle: Text('Get help with Millions'), //
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    launch('https://docs.millionsofficial.in/docs/intro');
                  }),
              ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('Report Bugs'),
                  subtitle: Text('Report bugs directly to us'), //
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    launch(
                        'https://docs.millionsofficial.in/docs/privacy/privacy-policy');
                  }),
              ListTile(
                  leading: Icon(Icons.contact_support),
                  title: Text('Support'),
                  // subtitle: Text('Get help with Millions'), //
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    launch(
                        'https://docs.millionsofficial.in/docs/bugs/support');
                  }),
              ListTile(
                leading: Icon(Icons.article),
                title: Text('Privacy Policy'),
                // subtitle: Text('Get help with Millions'), //
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  launch(
                      'https://docs.millionsofficial.in/docs/privacy/privacy-policy');
                },
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Terms of Service'),
                // subtitle: Text('Get help with Millions'), //
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  launch('https://docs.millionsofficial.in/docs/privacy/terms');
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_page),
                title: Text('Contact Us'),
                // subtitle: Text('Get help with Millions'), //
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  launch('https://millionsofficial.in/contact-us');
                },
              ),
            ],
          )),
        ],
      ),
    );
  }
}
