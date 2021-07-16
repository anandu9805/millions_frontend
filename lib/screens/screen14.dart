import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/screens/home.dart';
import 'package:millions/widgets/inputField.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Screen14 extends StatefulWidget {
  @override
  _Screen14State createState() => _Screen14State();
}

class _Screen14State extends State<Screen14> {
  var name, dname, phone, sex, dist, place, state, countr;
  List _selectedLanguages;
  bool countrySelected;
  //String selectedLanguage = 'English';
  String selectedCountry;
  String message;
  bool waiting;
  //get _usersStream => FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> updateUser() async {
    return users
        .doc(altUserId)
        .update({
          'name': dname.text,
          'gender': sex.text,
          'phone': phone.text,
          'country': countrySelected?selectedCountry:countr,
          'state': state.text,
          'district': dist.text,
          'place': place.text,
          'language' : _selectedLanguages
        })
        .then((value) => setState(() {message = "Profile Updated Successfully";}))
        .catchError((error) => setState(() {message = "Failed to update user: $error";}));
  }

  Future<void> getDetails() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(altUserId)
        .get()
        .then((value) {
      name = TextEditingController(text: value['realName']);
      dname = TextEditingController(text: value['name']);
      phone = TextEditingController(text: value['phone']);
      sex = TextEditingController(text: value['gender']);
      countr = value['country'];
      state = TextEditingController(text: value['state']);
      dist = TextEditingController(text: value['district']);
      place = TextEditingController(text: value['place']);
      _selectedLanguages = value['language'];
    });
  }

// void waitt() async{
//   await getDetails();
// }

  @override
  void initState() {
    countrySelected=false;
    message = "";
    waiting = true;
    super.initState();
    getDetails().whenComplete(() => setState(() {
          waiting = false;
        }));
    _selectedLanguages = [];
  }

  //static final _formKey = GlobalKey<FormState>();

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
      body: waiting
          ? Center(
              child: LoadingBouncingGrid.circle(
              borderColor: primary,
              backgroundColor: Colors.white,
              borderSize: 10,
              size: 100,
              duration: Duration(milliseconds: 1800),
            ))
          : SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18, top: 20),
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
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Name',
                            style: GoogleFonts.ubuntu(),
                          ),
                          InputField('', name, false),
                          SizedBox(height: 15),
                          Text(
                            'Display Name/Channel Name',
                            style: GoogleFonts.ubuntu(),
                          ),
                          InputField('', dname, false),
                          SizedBox(height: 15),
                          Text(
                            'Phone Number',
                            style: GoogleFonts.ubuntu(),
                          ),
                          InputField('', phone, false),
                          SizedBox(height: 15),
                          Text(
                            'Sex',
                            style: GoogleFonts.ubuntu(),
                          ),
                          InputField('', sex, false),
                          SizedBox(height: 15),
                          //InputField('Country', country, false),
                          Text(
                            'Video Country',
                            style: GoogleFonts.ubuntu(),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            //width: 20,
                            decoration: BoxDecoration(
                              // color: Colors.transparent,
                              border: Border.all(
                                color: primary,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                  countryListTheme: CountryListThemeData(
                                      textStyle: GoogleFonts.ubuntu(),
                                      inputDecoration: InputDecoration(
                                          focusColor: primary,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primary)))),
                                  context: context,
                                  showPhoneCode: false,
                                  // optional. Shows phone code before the country name.
                                  onSelect: (Country c) {
                                    //print('Select country: ${country.displayName}');
                                    setState(() {
                                      countrySelected = true;
                                      selectedCountry = c.countryCode;
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
                                  countrySelected ? selectedCountry : countr,
                                  style: GoogleFonts.ubuntu(),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),
                          Text(
                            'State',
                            style: GoogleFonts.ubuntu(),
                          ),
                          InputField('', state, false),
                          SizedBox(height: 15),
                          Text(
                            'District',
                            style: GoogleFonts.ubuntu(),
                          ),
                          InputField('', dist, false),
                          SizedBox(height: 15),
                          Text(
                            'Place',
                            style: GoogleFonts.ubuntu(),
                          ),
                          InputField('', place, false),
                          SizedBox(height: 20),
                          Text(
                            'Languages',
                            style: GoogleFonts.ubuntu(),
                          ),
                          // Container(
                          //   padding: EdgeInsets.only(left: 10),
                          //   //width: 20,
                          //   decoration: BoxDecoration(
                          //     // color: Colors.transparent,
                          //     border: Border.all(
                          //       color: primary,
                          //       width: 1,
                          //     ),
                          //   ),
                          //   child: DropdownButton(
                          //     dropdownColor: Colors.white,
                          //     elevation: 0,
                          //     style: GoogleFonts.ubuntu(),
                          //     // hint: Text('Please choose a location'), // Not necessary for Option 1
                          //     value: selectedLanguage,
                          //     onChanged: (newValue) {
                          //       setState(() {
                          //         selectedLanguage = newValue.toString();
                          //       });
                          //     },
                          //     items: lanuages.map((lang) {
                          //       return DropdownMenuItem(
                          //         child: new Text(
                          //           lang,
                          //           style:
                          //               GoogleFonts.ubuntu(color: Colors.black),
                          //         ),
                          //         value: lang,
                          //       );
                          //     }).toList(),
                          //   ),
                          // ),
                          //SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primary,
                                width: 1,
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
                                textStyle:
                                    GoogleFonts.ubuntu(color: Colors.white),
                                items: _selectedLanguages
                                    .map((e) => MultiSelectItem(e, e))
                                    .toList(),
                              ),
                            ),
                          ),
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
                                updateUser().whenComplete(() => 
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Millions",
                                        style: GoogleFonts.ubuntu(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        message,
                                       // "Profile Updated Successfully!",
                                        style: GoogleFonts.ubuntu(),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.ubuntu(
                                                color: primary),
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
                                ));
                              },
                              child: Text(
                                "Update",
                                style: GoogleFonts.ubuntu(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
