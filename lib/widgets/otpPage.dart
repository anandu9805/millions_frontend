import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/complete_profile.dart';

class OTPPageWidget extends StatefulWidget {
  //OTPPageWidget({Key key}) : super(key: key);
  @override
  _OTPPageWidgetState createState() => _OTPPageWidgetState();
}

class _OTPPageWidgetState extends State<OTPPageWidget> {
  //late TextEditingController otp1Controller;
  //late TextEditingController otp2Controller;
  //late TextEditingController otp3Controller;
  //late TextEditingController otp4Controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    //otp1Controller = TextEditingController();
    //otp2Controller = TextEditingController();
    //otp3Controller = TextEditingController();
    //otp4Controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(100, 75, 100, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      'Enter OTP',
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      //controller: otp1Controller,
                      obscureText: false,
                      decoration: InputDecoration(
                        //hintText: '0',
                        hintStyle: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: primary,
                              width: MediaQuery.of(context).size.width * 0.01),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      //controller: otp2Controller,
                      obscureText: false,
                      decoration: InputDecoration(
                        // hintText: '0',
                        hintStyle: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: primary,
                              width: MediaQuery.of(context).size.width * 0.01),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      //controller: otp3Controller,
                      obscureText: false,
                      decoration: InputDecoration(
                        //hintText: '0',
                        hintStyle: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primary,
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: primary,
                              width: MediaQuery.of(context).size.width * 0.01),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        //controller: otp4Controller,
                        obscureText: false,
                        decoration: InputDecoration(
                          // hintText: '0',
                          hintStyle: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: primary,
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: primary,
                                width:
                                    MediaQuery.of(context).size.width * 0.01),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                        ),
                        style: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: primary),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => CreateProfile()));
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.ubuntu(),
                    ),
                  )
                ],
              ),
              


            ],
          ),
        ),
      ),
    );
  }
}
