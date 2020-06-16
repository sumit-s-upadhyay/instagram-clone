import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/widgets/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Post Pictures");
final postReference = Firestore.instance.collection("Posts");
final DateTime timeStamp = DateTime.now();

class UploadPage extends StatefulWidget {
  final User gCurrentUser;
  final String profileURL;
  UploadPage(this.gCurrentUser,this.profileURL);

  @override
  _UploadPageState createState() => _UploadPageState(this.gCurrentUser,this.profileURL);
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {


  _UploadPageState(this.gCurrentUser,this.profileURL);

  final User gCurrentUser;
  final String profileURL;

  File file;
  bool isUploading = false;

  // Generate a v4 (random) id
  String postId = Uuid().v4();

  TextEditingController descTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  displayUploadScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, size: 100, color: Colors.black87),
          RaisedButton(
            color: Colors.brown,
            onPressed: () {
              takeImage(context);
            },
            child: Text(
              "Upload Image",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  takeImage(mcontext) {
    return showDialog(
        context: mcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "New Post",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Campture Image with Camera",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select Image Form Gallary",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: captureImageFromGallary,
              ),
              SimpleDialogOption(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              file != null
                  ? SimpleDialogOption(
                      child: Text(
                        "Remove Image",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          file = null;
                          Navigator.pop(context);
                        });
                      })
                  : Container(),
            ],
          );
        });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  captureImageFromGallary() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      debugPrint("inside getCurrentLocation method");

      Placemark mplacemark = placemark[0];
      String completeAddressInfo =
          "${mplacemark.subThoroughfare} ${mplacemark.thoroughfare}, ${mplacemark.subLocality} ${mplacemark.locality},  ${mplacemark.subAdministrativeArea} ${mplacemark.administrativeArea},  ${mplacemark.postalCode} ${mplacemark.country}";
      String specificAddress = ' ${mplacemark.locality} ${mplacemark.country}';

      locationTextEditingController.text = completeAddressInfo; 
    } catch (e) {
      print("Error Ocure");
      print(e.toString());
    }
  }

  compressSignInPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 90));

    setState(() {
      file = compressImageFile;
    });
  }

  controlUploadAndSave() async {
    setState(() {
      isUploading = true;
    });
    await compressSignInPhoto();
    String downloadUrl = await uploadPhoto(file);

    saveUserInfoToFirestore(
        photoUrl: downloadUrl,
        location: locationTextEditingController.text,
        description: descTextEditingController.text);

    locationTextEditingController.clear();
    descTextEditingController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Future<String> uploadPhoto(mFileImage) async {
    StorageUploadTask mstorageUploadTask =
        storageReference.child("Post_/$postId.jpg").putFile(mFileImage);
    StorageTaskSnapshot storageTaskSnapshot =
        await mstorageUploadTask.onComplete;
    String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  saveUserInfoToFirestore({String photoUrl, String location, String description}) {
    postReference.document(widget.gCurrentUser.id).setData({
      'postID': postId,
      'ownerId': widget.gCurrentUser.id,
      'timeStamp': timeStamp,
      'likes': {},
      'userName': widget.gCurrentUser.userName,
      'description': description,
      'location': location,
      'photoUrl': photoUrl,
    });
  }

  clearPostInfo() {
    locationTextEditingController.clear();
    descTextEditingController.clear();
    setState(() {
      file = null;
    });
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              clearPostInfo();
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: isUploading ? null : () => controlUploadAndSave(),
          )
        ],
      ),
      body: ListView(
        children: [
          isUploading ? LinearProgressIndicator() : Text(""),
          Container(
            height: 280.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white, 
              backgroundImage: widget.gCurrentUser.photoUrl != null 
                  ? NetworkImage(widget.profileURL) 
                  : NetworkImage(
                      "https://images.vexels.com/media/users/3/135246/isolated/preview/df491bf444acfa945630c22389140d4a-user-shadow-icon-by-vexels.png"),
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: descTextEditingController,
                decoration: InputDecoration(
                    hintText: "Enter describion here",
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_pin_circle),
            title: Container(
              width: 250,
              child: TextField(
                controller: locationTextEditingController,
                decoration: InputDecoration(
                    hintText: locationTextEditingController.text == null
                        ? "${locationTextEditingController.text}"
                        : "Enter You'r Location here",
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: 220,
              height: 50,
              child: RaisedButton(
                color: Colors.indigo,
                onPressed: () {
                  // print("${widget.gCurrentUser.photoUrl}");
                  // print("${widget.gCurrentUser.userName}");
                  getCurrentLocation();
                  print(descTextEditingController.text);
                  print(locationTextEditingController.text);
                },
                child: Text(
                  "Get Current Location",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
