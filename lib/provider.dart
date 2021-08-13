import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './screens/screen1.dart';

class MillionsProvider<context> extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount user;
  // GoogleSignInAccount get user => _user;
  var googleAuth;

  Future<User> googleLogin(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();
    print(googleUser.email);
    if (googleUser == null) return null;
    user = googleUser;
    googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
    print(FirebaseAuth.instance.currentUser.displayName);
    // await _prefs('userId', FirebaseAuth.instance.currentUser.uid);
    return FirebaseAuth.instance.currentUser;
  }

  Future logout(BuildContext context) async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
