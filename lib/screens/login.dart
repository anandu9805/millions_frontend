import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/googleSignIn.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/otpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Image.asset(
                    'images/white millions logo with millions.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white, padding: EdgeInsets.all(15)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GoogleSignIn()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_circle_up,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Sign Up",
                              style: GoogleFonts.ubuntu(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       width: MediaQuery.of(context).size.width * 0.9,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             primary: Colors.white, padding: EdgeInsets.all(15)),
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => OTPPageWidget()),
                //           );
                //         },
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Icon(
                //               Icons.login,
                //               color: Colors.black,
                //             ),
                //             SizedBox(
                //               width: 10,
                //             ),
                //             Text(
                //               "Login",
                //               style: GoogleFonts.ubuntu(
                //                   color: Colors.black,
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 20),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        'By creating an account you acknowledge that you agree to Million\'s ',
                    style:
                        GoogleFonts.ubuntu(fontSize: 12, color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: GoogleFonts.ubuntu(color: Colors.white, decoration: TextDecoration.underline, fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch(
                              "https://docs.millionsofficial.in/docs/privacy/terms"),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.ubuntu(
                            color: Colors.white, fontSize: 12),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.ubuntu(color: Colors.white,  decoration: TextDecoration.underline, fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch(
                              "https://docs.millionsofficial.in/docs/privacy/privacy-policy"),
                      ),
                    ],
                  ),
                ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
