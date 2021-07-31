
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  final User user;

  const CreateProfile({Key key, this.user}) : super(key: key);
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final currentuser = FirebaseAuth.instance.currentUser;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.user != null) {
      print(widget.user.displayName);
    }

    Future<QuerySnapshot<Map<String, dynamic>>> result = FirebaseFirestore
        .instance
        .collection('users')
        .where("uid", isEqualTo: widget.user.uid)
        .get();
    result.then((value) {
      if (value.docs.length > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController displayname = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController sex = TextEditingController();
    TextEditingController country = TextEditingController();
    TextEditingController state = TextEditingController();
    TextEditingController district = TextEditingController();
    TextEditingController place = TextEditingController();

    final millionsprovider =
        Provider.of<MillionsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Create Profile",
                      style: GoogleFonts.ubuntu(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 25),
                Column(
                  children: [
                    TextFormField(
                      cursorColor: primary,
                      controller: name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      cursorColor: primary,
                      controller: displayname,
                      decoration: InputDecoration(
                        labelText: 'Display Name/Channel Name',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      cursorColor: primary,
                      controller: email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      cursorColor: primary,
                      controller: sex,
                      decoration: InputDecoration(
                        labelText: 'Sex',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      cursorColor: primary,
                      controller: country,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      cursorColor: primary,
                      controller: state,
                      decoration: InputDecoration(
                        labelText: 'State',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      cursorColor: primary,
                      controller: district,
                      decoration: InputDecoration(
                        labelText: 'District',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      cursorColor: primary,
                      controller: place,
                      decoration: InputDecoration(
                        labelText: 'Place',
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primary)),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentuser.uid)
                          .set({
                        'accountCreatedFrom': 'Mobile',
                        'accountStatus': 'active',
                        'country': country.text,
                        'created': '00:00',
                        'district': district.text,
                        'email': email.text,
                        'gender': sex.text,
                        'isVerified': currentuser.emailVerified,
                        'language': 'lll',
                        'name': displayname.text,
                        'phone': currentuser.phoneNumber,
                        'place': place.text,
                        'profilePic': currentuser.photoURL,
                        'state': state.text,
                        'timestamp': '00:00',
                        'uid': currentuser.uid,
                      });
                      print("inside homepage");

                      String uid = widget.user.uid;
                      // FirebaseUser user = await _auth.currentUser();

                      // Get the token for this device
                      String fcmToken = await _fcm.getToken();
                      print(fcmToken);

                      // Save it to Firestore
                      if (fcmToken != null) {
                        var tokens = FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('tokens')
                            .doc(fcmToken);

                        await tokens.set({
                          'token': fcmToken,
                          'createdAt': FieldValue.serverTimestamp(), // optional
                          'platform': TargetPlatform.android // optional
                        });
                      }
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.ubuntu(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
