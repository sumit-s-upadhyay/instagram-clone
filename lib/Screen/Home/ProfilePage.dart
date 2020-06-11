import 'package:flutter/material.dart';
import 'package:instagram_clone_app/Model/Method.dart';


Method _method = Method();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          RaisedButton(
            onPressed: () {
              _method.signOutGoogle(context); 
            },
            child: Text("Logout"),
          )
        ],
      )),
    );
  }
}