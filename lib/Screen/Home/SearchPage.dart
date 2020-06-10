import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("SearchPage"),
        ],
      )),
    );
  }
}