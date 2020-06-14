import 'dart:async';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  String userName;

  onSumbitUser() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome " + userName));
      _scaffoldkey.currentState.showSnackBar(snackbar);

      Timer(Duration(seconds: 4), () {
        print("pop "); 
        Navigator.pop(context, userName);  
      });
    }
  }
  
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar( 
          title: Text("Profile"),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                   SizedBox(
                    height: 16.0,
                  ),

                  Text("Set UserName"),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    child: Form(
                       key: _formkey,
                      autovalidate: true, 
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter UserName",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        validator: (value) {
                          if (value.trim().length < 4 ||  value.isEmpty) {
                            return "Please Enter Correct Username"; 
                          } else {
                            print("Okkkkk");
                            return null;
                          }
                        },
                        onSaved: (value) => userName = value,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    color: Colors.red, 
                    onPressed: () {
                      onSumbitUser();
                    },
                    child: Text("Proceeed"),
                  )
                ],
              ),
            )
          ],
        )
      );
  }
}
