import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/pages/EditProfilePage.dart';
import 'package:instagram_clone_app/pages/HomePage.dart';

class ProfilePage extends StatefulWidget {
  final userProfileId;
  ProfilePage({this.userProfileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GoogleSignIn gSignIn = GoogleSignIn();

  //Signout Button
  signoutUser() {
    gSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  final String currentOnlineUserId = currentUser?.id;

  createProfileTopView() {
    return FutureBuilder(
      future: usersReference.document(widget.userProfileId).get(),
      builder: (context, datasnapshot) {
        if (!datasnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        User user = User.fromDocument(datasnapshot.data);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  
                    CircleAvatar(
                      backgroundColor: Colors.indigo,
                      radius: 42.0,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            CachedNetworkImageProvider(user.photoUrl),
                      ),
                    ),
                  
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            user.profileName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            createColumn("Post", 0),
                            createColumn("Folower", 5505),
                            createColumn("Followig", 1000),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            createButton(),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Wrap(
                children: [
                  Text(user.bio,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // Follower-Foolowing Button
  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return buttonTitleandFunction(
          title: "Edit Profile", performFunction: editUserProfile);
    }
  }

  buttonTitleandFunction({String title, Function performFunction}) {
    return Container(
      height: 26,
      width: 200, 
      child: RaisedButton(
        color: Colors.redAccent,
        onPressed: () {
         performFunction();  
        },
        child: Text(title),
      ),
    );
  }

  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditProfilePage(currentUserId: currentOnlineUserId)));
  }

  createColumn(String title, int count) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count.toString()),
          Container(
            child: Text(title),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                signoutUser();
              })
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 8.0,
          ),
          //create profile top View
          createProfileTopView(),
        ],
      ),
    );
  }
}
