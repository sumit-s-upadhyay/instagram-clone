import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/pages/HomePage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GoogleSignIn gSignIn = GoogleSignIn();

  signoutUser() {
    gSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          signoutUser();
        },
        child: Text("Sign Out"),
      ),
    );
  }
}
