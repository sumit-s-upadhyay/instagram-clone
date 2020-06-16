import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String userName;
  final String photoUrl;
  final String email;
  final String bio; 

  User({
    this.id,
    this.profileName,
    this.userName,
    this.photoUrl, 
    this.email,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc['email'],
      userName: doc['userName'],
      photoUrl: doc['photoUrl'],
      profileName: doc['profileName'],
      bio: doc['bio'],
    );
  }
}