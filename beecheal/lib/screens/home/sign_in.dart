import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.orange[400],
          elevation: 0.0,
          title: Text('Sign In'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: ElevatedButton(
                child: Text('Sign in Anonymously'), onPressed: () async {})));
  }
}
