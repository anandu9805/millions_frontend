import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class MillionsProvider extends ChangeNotifier{
  final googleSignIn=GoogleSignIn();
  GoogleSignInAccount _user;
  GoogleSignInAccount get user=>_user;
  var googleAuth;





  Future googleLogin() async {
    final googleUser=await googleSignIn.signIn();
    //print("googleUser");
    //print(googleUser);
    if(googleUser==null)
      return;
     googleAuth=await googleUser.authentication;
    final credential=GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );


    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
}
  Future logout () async{
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}