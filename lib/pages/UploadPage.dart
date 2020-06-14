import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  File file;

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
                   file !=null ? SimpleDialogOption(
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
                  }) : Container(),
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

  showImage() {
    return GestureDetector(
      onTap: () {
        takeImage(context);
      },
          child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(
          height: MediaQuery.of(context).size.height, 
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          image: FileImage(file),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : showImage();
  }
}
