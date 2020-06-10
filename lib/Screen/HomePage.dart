import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/Screen/Home/HomeScreen.dart';
import 'package:instagram_clone_app/Screen/SignIn/SignInScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isSignin = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  checkUser() async {
    try {
      bool usercheck = await googleSignIn.isSignedIn();
      print(usercheck);
      if (usercheck) {
        setState(() {
          isSignin = true;
        });
      } else {
        setState(() {
          isSignin = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSignin == true) {
      return HomeScreen();
    } else {
      return SignInScreen();
    }
  } 
}
   