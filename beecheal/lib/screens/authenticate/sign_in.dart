import 'package:flutter/material.dart';
import 'package:beecheal/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:flutter/gestures.dart';

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);

  final Function toggleSignIn;
  const SignIn({required this.toggleSignIn});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
              label: Text('Register'),
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
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.amber[400])),
                  onPressed: () async {
                    // Validation check
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signInEmail(email, password);
                      if (result == null) {
                        setState(() => error = 'Invalid email and/or password');
                      }
                    }
                  },
                  child: Text('Sign In',
                      style: TextStyle(color: Colors.brown[500])),
                ),
                SizedBox(height: 5.0),
                RichText(
                  text: TextSpan(
                    text: 'Forgot Password?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[500]),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String forgotEmail = '';
                                  final secondaryFormkey =
                                      GlobalKey<FormState>();
                                  return AlertDialog(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          16.0, 16.0, 16.0, 8.0),
                                      backgroundColor: Colors.orange[100],
                                      content: Form(
                                        key: secondaryFormkey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextFormField(
                                                decoration: textInputDecoration
                                                    .copyWith(
                                                        hintText: 'Email'),
                                                validator: (val) =>
                                                    EmailValidator.validate(
                                                            val!)
                                                        ? null
                                                        : 'Enter a valid email',
                                                onChanged: (val) {
                                                  setState(
                                                      () => forgotEmail = val);
                                                }),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.amber[400])),
                                              onPressed: () async {
                                                // Validation check
                                                if (secondaryFormkey
                                                    .currentState!
                                                    .validate()) {
                                                  dynamic result = await _auth
                                                      .forgotPassword(
                                                          forgotEmail);
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 1),
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                        return AlertDialog(
                                                            title: Text(
                                                                'Sent password reset email to ${forgotEmail}'));
                                                      });
                                                  if (result == null) {}
                                                }
                                              },
                                              child: Text('Reset password',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.brown[500])),
                                            ),
                                          ],
                                        ),
                                      ));
                                })
                          },
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0)),
              ]),
            )));
  }
}
