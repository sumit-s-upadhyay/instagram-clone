import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/Screen/SignIn/SignInScreen.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

class Method {

  //Signout Button
  void signOutGoogle(BuildContext context) async {
    await googleSignIn.signOut();
    print("User Sign Out");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  
}
