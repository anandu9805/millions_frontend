import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/provider.dart';
import 'package:millions/screens/myWallet.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/screen14.dart';
import 'package:provider/provider.dart';

class UserOptions extends StatefulWidget {
  // const UserOptions({ Key? key }) : super(key: key);

  @override
  _UserOptionsState createState() => _UserOptionsState();
}

class _UserOptionsState extends State<UserOptions> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (BuildContext context) {
      return <PopupMenuEntry>[
        PopupMenuItem(
          child: Text(
            "Edit Profile",
            style: GoogleFonts.ubuntu(),
          ),
          value: 'editprofile',
        ),
        PopupMenuItem(
          child: Text("My Wallet", style: GoogleFonts.ubuntu()),
          value: 'mywallet',
        ),
        PopupMenuItem(
          child: Text("My Channel", style: GoogleFonts.ubuntu()),
          value: 'mychannel',
        ),
        PopupMenuItem(
          child: Text("Logout", style: GoogleFonts.ubuntu()),
          value: 'logout',
        ),
      ];
    }, onSelected: (value) {
      if (value == 'logout') {
        final millionsprovider =
            Provider.of<MillionsProvider>(context, listen: false);
        millionsprovider.logout();
      } else if (value == 'mywallet') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyWallet()),
        );
      } else if (value == 'mychannel') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Page8(altUserId)),
        );
      } else if (value == 'editprofile') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Screen14()),
        );
      }
    });
  }
}
