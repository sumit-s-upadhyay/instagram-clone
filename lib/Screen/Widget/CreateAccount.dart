import 'dart:async';

import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
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
        Navigator.pop(context, userName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text("Set UserName"),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter UserName",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        validator: (value) {
                          if (value.trim().length > 4 ||
                              value.trim().isNotEmpty) {
                            return "Please Enter Correct Username";
                          } else {
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
                    onPressed: () {
                      onSumbitUser();
                    },
                    child: Text("data"),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
