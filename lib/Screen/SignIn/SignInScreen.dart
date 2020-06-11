import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/Model/user.dart';
import 'package:instagram_clone_app/Screen/Home/HomeScreen.dart';
import 'package:instagram_clone_app/Screen/Widget/CreateAccount.dart';
import 'package:instagram_clone_app/Style/Style.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      if (user != null)  {
        print(user.email);
         saveUserInfo();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
        );
      }

      return 'signInWithGoogle succeeded: $user';
    } catch (e) {
      print("Error Occure ******************");
      print(e.toString());
    }
  }


    saveUserInfo() async {
    print("saveUserInfo");
    final GoogleSignInAccount googleSignInCurrentUser =   googleSignIn.currentUser;  
    print("googleSignInCurrentUser: $googleSignInCurrentUser");
    DocumentSnapshot documentSnapshot =  await userReference.document(googleSignInCurrentUser.id).get();
    print("documentSnapshot");

    if (documentSnapshot.exists) { 
      print("Navigator to CreateAccount ");
      final userName = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      userReference.document(googleSignInCurrentUser.id).setData({
        'id': googleSignInCurrentUser.id,
        'profileName': googleSignInCurrentUser.displayName,
        'userName': userName,
        'url': googleSignInCurrentUser.photoUrl,
        'email': googleSignInCurrentUser.email,
        'bio': '',
        'timeStamp': timeStamp 
      });
      documentSnapshot = await userReference.document(googleSignInCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Instagram",
              style: GoogleFonts.grandHotel(
                textStyle: ThemeText.loginTitle,
              )
            ),
          SizedBox(
            height: 16.0,
          ),
          RaisedButton(
            onPressed: () {
              signInWithGoogle();
            },
            child: Text("Login"),
          ),
        ],
      )
     ),
    );
  }
}
