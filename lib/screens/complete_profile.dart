import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:millions/widgets/inputField.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  final String uid;

  const CreateProfile({Key key, this.uid}) : super(key: key);
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  final currentuser = FirebaseAuth.instance.currentUser;
  TextEditingController name = TextEditingController();
  TextEditingController displayname = TextEditingController();
  TextEditingController phone = TextEditingController();
  List _selectedLanguages;
  bool countrySelected, stateSelected;
  Country _selectedCountry;
  String _selectedGender, _selectedDistrict, _selectedState, _selectedStateCode;
  TextEditingController place = TextEditingController();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedLanguages = ["English", "Malayalam", "Tamil"];
    countrySelected = false;
    stateSelected = false;
    _selectedGender = "Male";
    print(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final millionsprovider =
        Provider.of<MillionsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "It only takes one minute!",
                      style: GoogleFonts.ubuntu(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Your Name',
                        style: GoogleFonts.ubuntu(),
                      ),
                      InputField('', name, 1),
                      SizedBox(height: 15),
                      Text(
                        'Display Name/Channel Name',
                        style: GoogleFonts.ubuntu(),
                      ),
                      InputField('', displayname, 1),
                      SizedBox(height: 15),
                      Text(
                        'Phone Number (Without Country Code)',
                        style: GoogleFonts.ubuntu(),
                      ),
                      TextFormField(
                        cursorColor: primary,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 10) {
                            return 'Please enter a valid 10 digit mobile number';
                          }
                          return null;
                        },
                        controller: phone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0),
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
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Gender',
                        style: GoogleFonts.ubuntu(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ), //BorderRadi
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            elevation: 0,
                            style: GoogleFonts.ubuntu(),
                            value: _selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedGender = newValue.toString();
                              });
                            },
                            items: genderList.map((gend) {
                              return DropdownMenuItem(
                                child: new Text(
                                  gend,
                                  style:
                                      GoogleFonts.ubuntu(color: Colors.black),
                                ),
                                value: gend,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Country',
                        style: GoogleFonts.ubuntu(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        //width: 20,
                        decoration: BoxDecoration(
                          // color: Colors.transparent,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ), //B
                        ),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              countryListTheme: CountryListThemeData(
                                  textStyle: GoogleFonts.ubuntu(),
                                  inputDecoration: InputDecoration(
                                      focusColor: primary,
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primary)))),
                              context: context,
                              showPhoneCode: false,
                              // optional. Shows phone code before the country name.
                              onSelect: (Country c) {
                                //print('Select country: ${country.displayName}');
                                setState(() {
                                  countrySelected = true;
                                  print(c.displayName);
                                  _selectedCountry = c;

                                  _selectedStateCode = 'KL';
                                  print(_selectedCountry.countryCode);
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Text(
                              countrySelected ? _selectedCountry.name : "",
                              style: GoogleFonts.ubuntu(),
                            ),
                          ),
                        ),
                      ),
                      if (countrySelected &&
                          _selectedCountry.countryCode == "IN")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text(
                              'State',
                              style: GoogleFonts.ubuntu(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  elevation: 0,
                                  style: GoogleFonts.ubuntu(),
                                  value: indianStates[_selectedStateCode],
                                  onChanged: (newValue) {
                                    setState(() {
                                      stateSelected = true;
                                      // _selectedState = newValue.toString();
                                      _selectedStateCode = indianStates.keys
                                          .firstWhere(
                                              (k) =>
                                                  indianStates[k] ==
                                                  newValue.toString(),
                                              orElse: () => null);
                                      _selectedDistrict =
                                          indianDistricts[_selectedStateCode]
                                              .first
                                              .toString();
                                    });
                                  },
                                  items: indianStates.values.map((stt) {
                                    return DropdownMenuItem(
                                      child: new Text(
                                        stt,
                                        style: GoogleFonts.ubuntu(
                                            color: Colors.black),
                                      ),
                                      value: stt,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'District',
                              style: GoogleFonts.ubuntu(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  elevation: 0,
                                  style: GoogleFonts.ubuntu(),
                                  value: _selectedDistrict,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedDistrict = newValue.toString();
                                    });
                                  },
                                  items: indianDistricts[_selectedStateCode]
                                      .map((distri) {
                                    return DropdownMenuItem(
                                      child: new Text(
                                        distri,
                                        style: GoogleFonts.ubuntu(
                                            color: Colors.black),
                                      ),
                                      value: distri,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Place',
                              style: GoogleFonts.ubuntu(),
                            ),
                            InputField('', place, 1),
                          ],
                        ),
                      SizedBox(height: 15),
                      Text(
                        'Select Video Languages',
                        style: GoogleFonts.ubuntu(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        child: MultiSelectDialogField(
                          checkColor: Colors.white,
                          selectedColor: primary,
                          itemsTextStyle: GoogleFonts.ubuntu(),
                          title: Text(
                            "Select Language",
                            style: GoogleFonts.ubuntu(),
                          ),
                          buttonText: Text("Select Language",
                              style: GoogleFonts.ubuntu()),
                          items: languages
                              .map((l) => MultiSelectItem<String>(l, l))
                              .toList(),
                          initialValue: _selectedLanguages,
                          onConfirm: (val) {
                            setState(() {
                              _selectedLanguages = val;
                            });
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            chipColor: primary,
                            textStyle: GoogleFonts.ubuntu(color: Colors.white),
                            items: _selectedLanguages
                                .map((e) => MultiSelectItem(e, e))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    text:
                        'By creating an account you acknowledge that you agree to Million\'s ',
                    style:
                        GoogleFonts.ubuntu(fontSize: 10, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: GoogleFonts.ubuntu(color: primary, fontSize: 10),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch(
                              "https://docs.millionsofficial.in/docs/privacy/terms"),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.ubuntu(
                            color: Colors.black, fontSize: 12),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.ubuntu(color: primary, fontSize: 10),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch(
                              "https://docs.millionsofficial.in/docs/privacy/privacy-policy"),
                      ),
                    ],
                  ),
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
                        'country':
                            countrySelected ? _selectedCountry.countryCode : '',
                        'created': Timestamp.now(),
                        'district': _selectedDistrict,
                        'email': currentuser.email,
                        'gender': _selectedGender,
                        'isVerified': currentuser.emailVerified,
                        'language': _selectedLanguages,
                        'name': displayname.text,
                        'phone': countrySelected
                            ? '+' + _selectedCountry.phoneCode + phone.text
                            : phone.text,
                        'place': place.text,
                        'profilePic': currentuser.photoURL,
                        'state': _selectedStateCode,
                        'timestamp': Timestamp.now(),
                        'uid': currentuser.uid,
                      });
                      await FirebaseFirestore.instance
                          .collection('channels')
                          .doc(currentuser.uid)
                          .set({
                        'accountStatus': 'active',
                        'channelArt': "",
                        'channelName': displayname.text,
                        'channelScore': 0,
                        'country':
                            countrySelected ? _selectedCountry.countryCode : '',
                        'created': Timestamp.now(),
                        'dateChanged': Timestamp.now(),
                        'description': "",
                        'email': currentuser.email,
                        'id': currentuser.uid,
                        'isVerified': false,
                        'linkone': "",
                        'linktwo': "",
                        'linkthree' : "",
                        'linkfour' : "",
                        'linkfive' : "",
                        'profilePic': currentuser.photoURL,
                        'realName': displayname.text,
                        'subscribers': 1,
                        'videos': 0
                      });
                      print("inside homepage");

                      String uid = widget.uid;
                      // FirebaseUser user = await _auth.currentUser();

                      // Get the token for this device

                      String fcmToken = await _fcm.getToken();
                      print(fcmToken);

                      // Save it to Firestore
                      if (fcmToken != null) {
                        var tokens = FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('notificationTokens')
                            .doc(fcmToken);

                        await tokens.set({
                          'token': fcmToken,
                          'createdAt': FieldValue.serverTimestamp(), // optional
                          'platform': "Mobile" // optional
                        });
                      }

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                    },
                    child: Text(
                      "Finish",
                      style: GoogleFonts.ubuntu(fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(height: 52),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
