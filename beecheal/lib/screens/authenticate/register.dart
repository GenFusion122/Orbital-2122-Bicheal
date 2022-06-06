import 'package:beecheal/custom%20widgets/constants.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/services/database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  final Function toggleSignIn;
  Register({required this.toggleSignIn});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.orange[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              style: TextButton.styleFrom(primary: Colors.brown[500]),
              label: Text('Sign In'),
              onPressed: () {
                widget.toggleSignIn();
              },
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                SizedBox(height: 20.0),
                // Email input
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => EmailValidator.validate(val!)
                        ? null
                        : 'Enter a valid email',
                    onChanged: (val) {
                      setState(() => email = val);
                    }),
                SizedBox(height: 20.0),
                // Password input
                TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (val) => val!.length < 8
                        ? 'Enter a password at least 8 characters long'
                        : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child:
                      Text('Register', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.amber[400])),
                  onPressed: () async {
                    // validation check
                    if (_formKey.currentState!.validate()) {
                      dynamic result =
                          await _auth.registerEmail(email, password);
                      if (result == null) {
                        setState(() => error = 'Invalid email');
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0)),
              ]),
            )));
  }
}
