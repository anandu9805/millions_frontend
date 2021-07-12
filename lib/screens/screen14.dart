import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/home.dart';
import 'package:millions/widgets/inputField.dart';

class Screen14 extends StatefulWidget {
  @override
  _Screen14State createState() => _Screen14State();
}

class _Screen14State extends State<Screen14> {
  var name, dname, email, sex, dist, country, place, state;

  String message = "";
  //get _usersStream => FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> updateUser() {
    return users
        .doc(altUserId)
        .update({
          'name': dname.text,
          'country': country.text,
          'state': state.text,
          'district': dist.text,
          'place': place.text
        })
        .then((value) => message = "Profile Updated Successfully")
        .catchError((error) => message = "Failed to update user: $error");
  }

  @override
  Widget build(BuildContext context) {
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
                      "Edit Profile",
                      style: GoogleFonts.ubuntu(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 25),
                FutureBuilder<DocumentSnapshot>(
                  future: users.doc(altUserId).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "Something went wrong",
                        style: GoogleFonts.ubuntu(fontSize: 20),
                      );
                    }

                    if (snapshot.hasData && !snapshot.data.exists) {
                      return Text(
                        "Document does not exist",
                        style: GoogleFonts.ubuntu(fontSize: 20),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data.data() as Map<String, dynamic>;
                      name = TextEditingController(text: data['realName']);
                      dname = TextEditingController(text: data['name']);
                      email = TextEditingController(text: data['email']);
                      sex = TextEditingController(text: data['gender']);
                      country = TextEditingController(text: data['country']);
                      state = TextEditingController(text: data['state']);
                      dist = TextEditingController(text: data['district']);
                      place = TextEditingController(text: data['place']);
                      return Column(
                        children: [
                          InputField('Name', name, true),
                          SizedBox(height: 15),
                          InputField('Display Name/Channel Name', dname, false),
                          SizedBox(height: 15),
                          InputField('Email', email, true),
                          SizedBox(height: 15),
                          InputField('Sex', sex, true),
                          SizedBox(height: 15),
                          InputField('Country', country, false),
                          SizedBox(height: 15),
                          InputField('State', state, false),
                          SizedBox(height: 15),
                          InputField('District', dist, false),
                          SizedBox(height: 15),
                          InputField('Place', place, false),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primary)),
                              onPressed: () {
                                //print(name.text);
                                updateUser();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Millions",
                                        style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        //message,
                                        "Profile Updated Successfully!",
                                        style: GoogleFonts.ubuntu(),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.ubuntu(color: primary),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            HomePage()));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Update",
                                style: GoogleFonts.ubuntu(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return CircularProgressIndicator(
                      color: primary,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
