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
    this.bio
  });

  factory User.fromDocument(DocumentSnapshot documentSnapshot) {
   return User(
     id: documentSnapshot.documentID,
     email: documentSnapshot['email'],
     userName: documentSnapshot['userName'],
     photoUrl: documentSnapshot['photoUrl'],
     profileName: documentSnapshot['displayName'],
     bio: documentSnapshot['bio'],    
   ); 
  }
  
}