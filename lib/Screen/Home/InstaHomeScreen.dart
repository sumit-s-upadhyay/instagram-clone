import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone_app/Style/Style.dart';

class InstaHomeScreen extends StatefulWidget {
  @override
  _InstaHomeScreenState createState() => _InstaHomeScreenState();
}

class _InstaHomeScreenState extends State<InstaHomeScreen> { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1.0,
          title: Text("Instagram",
              style: GoogleFonts.grandHotel(
                textStyle: ThemeText.titleText,
              )),
          leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.camera, color: Colors.black),
              onPressed: () {
                //add stories
              }),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                icon: FaIcon(FontAwesomeIcons.paperPlane, color: Colors.black),
                onPressed: () {
                  //share button
                }),
          ],
        ),
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