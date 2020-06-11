import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/Model/user.dart';
import 'package:instagram_clone_app/Screen/Home/InstaHomeScreen.dart';
import 'package:instagram_clone_app/Screen/Home/NotificationPage.dart';
import 'package:instagram_clone_app/Screen/Home/ProfilePage.dart';
import 'package:instagram_clone_app/Screen/Home/SearchPage.dart';
import 'package:instagram_clone_app/Screen/Home/UploadPage.dart';

final userReference = Firestore.instance.collection("users");
User currentUser;

final DateTime timeStamp = DateTime.now();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser logInUser;
  int getPageIndex = 0;

  PageController pageController;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        print("inside homescrren");
        logInUser = user;
        print(logInUser.email);
      }
    } catch (e) {
      print(e.toString());
    }
  }


  
  whenPageChanges(var pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTabPageChange(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          InstaHomeScreen(),
          SearchPage(),
          UploadPage(),
          NotificationPage(),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTabPageChange,
        activeColor: Colors.black,
        inactiveColor: Colors.black54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
