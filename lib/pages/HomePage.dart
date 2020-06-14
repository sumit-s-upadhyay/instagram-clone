import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/pages/CreateAccountPage.dart';
import 'package:instagram_clone_app/pages/NotificationsPage.dart';
import 'package:instagram_clone_app/pages/ProfilePage.dart';
import 'package:instagram_clone_app/pages/SearchPage.dart';
import 'package:instagram_clone_app/pages/TimeLinePage.dart';
import 'package:instagram_clone_app/pages/UploadPage.dart';
import 'package:instagram_clone_app/widgets/User.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection("users");
final DateTime timeStamp = DateTime.now();
User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignIn = false;

  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((googleSignInAccount) {
      controlSignIn(googleSignInAccount);
      print(googleSignInAccount.email);
    }, onError: (e) {
      print("Error Message  :" + e);
    });

    gSignIn
        .signInSilently(
      suppressErrors: false,
    )
        .then((googleSignInAccount) {
      print(googleSignInAccount.email);
      controlSignIn(googleSignInAccount);
    }).catchError((e) {
      print("Error Message  :" + e);
    });
  }

  loginUser() {
    gSignIn.signIn();
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfotoFirebase();
      setState(() {
        print(" isSignIn true");
        isSignIn = true;
        print(signInAccount.email);
      });
    } else {
      setState(() {
        print(" isSignIn false");
        isSignIn = false;
      });
    }
  }

  saveUserInfotoFirebase() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot = await usersReference.document(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
     
      final userName = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
      print("userName :$userName");

      usersReference.document(gCurrentUser.id).setData({
        'id': gCurrentUser.id,
        'profileName': gCurrentUser.displayName,
        'userName': userName, 
        'url': gCurrentUser.photoUrl,
        'email': gCurrentUser.email,
        'bio': '', 
        'timeStamp': timeStamp
      });
      documentSnapshot = await usersReference.document(gCurrentUser.id).get();
      print("documentSnapshot :$documentSnapshot");
    }
    print("Not exist");
    currentUser = User.fromDocument(documentSnapshot);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  int getPageIndex = 0;
  whenPageChanges(var pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  onTabPageChange(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLinePage(),
          SearchPage(),
          UploadPage(),
          NotificationsPage(),
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

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Instagram",
                style: GoogleFonts.grandHotel(
                  fontSize: 48.0,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.indigo,
                onPressed: () {
                  loginUser();
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignIn == true) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}
