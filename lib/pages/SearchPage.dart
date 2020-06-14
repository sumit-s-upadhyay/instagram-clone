
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/user.dart';

final usersReference = Firestore.instance.collection("users");

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController;
  Future<QuerySnapshot> futureSearchResults;

  AppBar searchPageUser() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchTextEditingController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            hintText: "Search User",
            filled: true,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
            suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    emptyTextFormField();
                  });
                })),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  controlSearching(String str) {
    Future<QuerySnapshot> allUser = usersReference
        .where("profileName", isGreaterThanOrEqualTo: str)
        .getDocuments();
    setState(() {
      futureSearchResults = allUser;
    }); 
  }

  emptyTextFormField() {
    searchTextEditingController.clear(); 
  }

  Container displaySearchResultScreen() {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(
              Icons.group,
              color: Colors.black54,
              size: 100,
            ),
            Text(
              "Search User",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot ) {
        if (!dataSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.indigo,
          )
         ); 
        } 

        List<UserResult> searchUserResult = [];
        dataSnapshot.data.documents.forEach((document) {
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser);

          searchUserResult.add(userResult);

        });
        return ListView( 
          children: searchUserResult
        );
      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageUser(),
      body: futureSearchResults == null ? displaySearchResultScreen() : displayUserFoundScreen(),
    );
  }

}

class UserResult extends StatelessWidget {

  final User eachUser;

  UserResult(this.eachUser);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap:  () {
               print("Tapped");
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: CachedNetworkImageProvider(eachUser.url),
              ),
              title: Text("${eachUser.profileName}",
              style: TextStyle(
                color: Colors.black
              ),
              ),
              subtitle: Text("${eachUser.userName}",  
              style: TextStyle(
                color: Colors.grey
              ),
              ),
            ),
           
          )
        ],
      ),
    );
  }
}
