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
  final _formCreateKey = GlobalKey<FormState>();
  TextEditingController name, dname, phone, place;
  var countr;String tempPhone;
  List _selectedLanguages;
  bool countrySelected, stateSelected;
  Country _selectedCountry;
  String _selectedGender, _selectedDistrict, _selectedStateCode;
  String message;
  bool waiting;
  //get _usersStream => FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: primary,
        ),
      ),
    );
  }

  void updateUser() async {
    try {
      setState(() {
        waiting = true;
      });
      await users.doc(altUserId).update({
        'name': dname.text,
        'gender': _selectedGender,
        'phone': countrySelected ? '+' + _selectedCountry.phoneCode + phone.text:tempPhone,
        'country': countrySelected ? _selectedCountry.countryCode : countr,
        'state': _selectedStateCode,
        'district': _selectedDistrict,
        'place': place.text,
        'language': _selectedLanguages
      }).whenComplete(() {
        _showToast(context, "Profile Updated Successfully");
        setState(() {
          waiting = false;
        });
        //Navigator.pop(context);
      }).catchError(
          (error) => _showToast(context, "Failed to update profile: $error"));
    } catch (e) {
      print("Error"+e.toString());
    }
  }

  Future<void> getDetails() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(altUserId)
        .get()
        .then((value) {
      name = TextEditingController(text: value['name']);
      dname = TextEditingController(text: value['name']);
      tempPhone = value['phone'];
      phone = TextEditingController(text: tempPhone.substring(3));
      //phone.text=phone.text.substring(2);
      _selectedGender = value['gender'];
      countr = value['country'];
      _selectedStateCode = value['state'];
      _selectedDistrict = value['district'];
      place = TextEditingController(text: value['place']);
      _selectedLanguages = value['language'];
    });
  }

// void waitt() async{
//   await getDetails();
// }

  @override
  void initState() {
    countrySelected = false;
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
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formCreateKey,
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
                            InputField('', name, 1),
                            SizedBox(height: 15),
                            Text(
                              'Display Name/Channel Name',
                              style: GoogleFonts.ubuntu(),
                            ),
                            InputField('', dname, 1),
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
                            Text(
                              'Gender',
                              style: GoogleFonts.ubuntu(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primary,
                                  width: 1,
                                ),
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
                                        style: GoogleFonts.ubuntu(
                                            color: Colors.black),
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
                                        //print(c.displayName);
                                        _selectedCountry = c;
                                       // print(_selectedCountry.countryCode);
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
                                    countrySelected
                                        ? _selectedCountry.name
                                        : countr,
                                    style: GoogleFonts.ubuntu(),
                                  ),
                                ),
                              ),
                            ),
                            if ((countrySelected &&
                                    _selectedCountry.countryCode == "IN") ||
                                (!countrySelected && countr == "IN"))
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
                                        color: primary,
                                        width: 1,
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
                                            _selectedStateCode =
                                                indianStates.keys.firstWhere(
                                                    (k) =>
                                                        indianStates[k] ==
                                                        newValue.toString(),
                                                    orElse: () => null);
                                            _selectedDistrict = indianDistricts[
                                                    _selectedStateCode]
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
                                        color: primary,
                                        width: 1,
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
                                            _selectedDistrict =
                                                newValue.toString();
                                          });
                                        },
                                        items:
                                            indianDistricts[_selectedStateCode]
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
                            SizedBox(height: 20),
                            Text(
                              'Languages',
                              style: GoogleFonts.ubuntu(),
                            ),
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
                                  updateUser();
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
            ),
    );
  }
}
