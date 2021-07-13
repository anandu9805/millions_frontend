import 'package:flutter/material.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/myWallet.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/screen14.dart';

class DefaultDrawer extends StatefulWidget {
  //const DefaultDrawer({ Key? key }) : super(key: key);

  @override
  _DefaultDrawerState createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Screen14()),
              );
            },
          ),
          // ListTile(
          //   title: Text('Payment Verification'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => PaymentVerifcationPage()),
          //     );
          //   },
          // ),
          ListTile(
            title: Text('My Wallet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyWallet()),
              );
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('My Channel'),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Page8(altUserId)),
              );
            },
          ),
        ],
      ),
    );
  }
}
