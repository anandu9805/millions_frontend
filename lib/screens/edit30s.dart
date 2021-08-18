import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/reels_model.dart';
import 'package:millions/widgets/inputField.dart';

class Edit30s extends StatefulWidget {
  //const EditPost({ Key? key }) : super(key: key);
  final String myReelId;
  Edit30s(this.myReelId);

  @override
  _Edit30sState createState() => _Edit30sState();
}

class _Edit30sState extends State<Edit30s> {
  String selectedLanguage, selectedCountry;
  bool _isLoading, countrySelected = false;
  Reels reel;
  TextEditingController descontroller, titlecontroller;

  Future<void> getDetails() async {
    return FirebaseFirestore.instance
        .collection('reels')
        .doc(widget.myReelId)
        .get()
        .then((value) {
      reel = Reels.fromMap(value.data());
      selectedLanguage = reel.language;
      selectedCountry = reel.country;
      titlecontroller = TextEditingController(text: reel.title);
      descontroller = TextEditingController(text: reel.description);
    });
  }

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

  void updatePost() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('reels')
          .doc(widget.myReelId)
          .update({
        'title': titlecontroller.text,
        'description': descontroller.text,
        'language': selectedLanguage,
        'country': selectedCountry
      }).then((value) {
        _showToast(context, "30s Updated Successfully");
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }).catchError(
              (error) => _showToast(context, "Failed to update 30s: $error"));
    } catch (e) {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getDetails().whenComplete(() => setState(() {
          _isLoading = false;
        }));
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
      body: _isLoading
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
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Edit 30s",
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
                          '30s Title',
                          style: GoogleFonts.ubuntu(),
                        ),
                        InputField("", titlecontroller, 2),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          '30s Description',
                          style: GoogleFonts.ubuntu(),
                        ),
                        InputField("", descontroller, 6),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Language',
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
                              value: selectedLanguage,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedLanguage = newValue.toString();
                                  // print("object" + commentStatus);
                                });
                              },
                              items: languages.map((lang) {
                                return DropdownMenuItem(
                                  child: new Text(
                                    lang,
                                    style:
                                        GoogleFonts.ubuntu(color: Colors.black),
                                  ),
                                  value: lang,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country c) {
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
                                countrySelected
                                    ? selectedCountry
                                    : reel.country,
                                style: GoogleFonts.ubuntu(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: primary),
                        onPressed: () {
                          updatePost();
                        },
                        child: Text(
                          "Update",
                          style: GoogleFonts.ubuntu(fontSize: 15),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}
