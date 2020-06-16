import "package:flutter/material.dart";

class EditProfilePage extends StatefulWidget {  

  final String currentUserId;
  EditProfilePage({this.currentUserId});
  
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Text('Here goes Edit Profile Page');
  }
}
