import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/home.dart';
import 'package:millions/widgets/inputField.dart';

class Screen14 extends StatefulWidget {
  @override
  _Screen14State createState() => _Screen14State();
}

class _Screen14State extends State<Screen14> {
final name = TextEditingController();
final dname = TextEditingController();
final email = TextEditingController();
final sex = TextEditingController();
final dist = TextEditingController();
final country = TextEditingController();
final place = TextEditingController();
final state = TextEditingController();
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
                Column(
                  children: [
                    InputField('Name', name),
                    SizedBox(height: 15),
                    InputField('Display Name/Channel Name', dname),
                    SizedBox(height: 15),
                    InputField('Email', email),
                    SizedBox(height: 15),
                    InputField('Sex', sex),
                    SizedBox(height: 15),
                    InputField('Country', country),
                    SizedBox(height: 15),
                    InputField('State', state),
                    SizedBox(height: 15),
                    InputField('District', dist),
                    SizedBox(height: 15),
                    InputField('Place', place),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primary)),
                    onPressed: () {
                      //print(name.text);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                    },
                    child: Text(
                      "Update",
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
