import 'package:flutter/material.dart';

class InstaHomeScreen extends StatefulWidget {
  @override
  _InstaHomeScreenState createState() => _InstaHomeScreenState();
}

class _InstaHomeScreenState extends State<InstaHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("InstaHome"),
        ],
      )),
    );
  }
}