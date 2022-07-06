import 'dart:math';

import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/custom%20widgets/loading.dart';
import 'package:beecheal/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hexagon/hexagon.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  // final Function toggleSignIn;
  // Register({required this.toggleSignIn});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  // loading screen
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String confirm = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              // widget.toggleSignIn();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(children: [
          Positioned(
            right: -(MediaQuery.of(context).size.width * 0.45),
            top: 0.0,
            child: HexagonWidget.flat(
              color: Color(0xFFFFAB00),
              width: (MediaQuery.of(context).size.width * 3),
            ),
          ),
          SafeArea(
            child: loading
                ? Loading()
                : Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            (MediaQuery.of(context).size.width * 0.075)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Email input
                            TextFormField(
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xff000000)),
                                cursorColor: Color(0xff000000),
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Email'),
                                validator: (val) =>
                                    EmailValidator.validate(val!)
                                        ? null
                                        : 'Enter a valid email',
                                onChanged: (val) {
                                  setState(() => email = val);
                                }),
                            SizedBox(height: 20.0),
                            // Password input
                            TextFormField(
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xff000000)),
                                cursorColor: Color(0xff000000),
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Password'),
                                validator: (val) => val!.length < 8
                                    ? 'Enter a password at least 8 characters long'
                                    : null,
                                obscureText: true,
                                onChanged: (val) {
                                  setState(() => password = val);
                                }),
                            SizedBox(height: 20.0),
                            // Password input
                            TextFormField(
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xff000000)),
                                cursorColor: Color(0xff000000),
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Confirm Password'),
                                validator: (val) => val != password
                                    ? 'Passwords don\'t match'
                                    : null,
                                obscureText: true,
                                onChanged: (val) {
                                  setState(() => confirm = val);
                                }),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(Size(
                                      (MediaQuery.of(context).size.width *
                                          0.85),
                                      (MediaQuery.of(context).size.width *
                                          0.1))),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFFFDD4b)),
                                  elevation:
                                      MaterialStateProperty.resolveWith<double>(
                                          (states) => 0)),
                              onPressed: () async {
                                // validation check
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result = await _auth.registerEmail(
                                      email, password);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Invalid email';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              child: Text('Register',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff000000))),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
                          ]),
                    )),
          ),
        ]));
  }
}
