import 'package:beecheal/screens/authenticate/register.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:hexagon/hexagon.dart';

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);

  // final Function toggleSignIn;
  // const SignIn({required this.toggleSignIn});

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFE0B2),
      appBar: null,
      body: Stack(children: [
        Positioned(
          left: -(MediaQuery.of(context).size.width * 0.45),
          top: 0.0,
          child: HexagonWidget.flat(
            color: Color(0xFFFFAB00),
            width: (MediaQuery.of(context).size.width * 3),
          ),
        ),
        SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width * 0.075)),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/BzB.png',
                          height: (MediaQuery.of(context).size.width * 0.5),
                          width: (MediaQuery.of(context).size.width * 0.5),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Email input
                      TextFormField(
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff000000)),
                          cursorColor: Color(0xff000000),
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) => EmailValidator.validate(val!)
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
                      SizedBox(height: 12.5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                            text: 'Forgot Password?',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String forgotEmail = '';
                                          final secondaryFormkey =
                                              GlobalKey<FormState>();
                                          return AlertDialog(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      16.0, 16.0, 16.0, 8.0),
                                              backgroundColor:
                                                  Color(0xFFFFC95C),
                                              content: Form(
                                                key: secondaryFormkey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    TextFormField(
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Color(
                                                                0xff000000)),
                                                        cursorColor:
                                                            Color(0xff000000),
                                                        decoration:
                                                            textInputDecoration
                                                                .copyWith(
                                                                    hintText:
                                                                        'Email'),
                                                        validator: (val) =>
                                                            EmailValidator
                                                                    .validate(
                                                                        val!)
                                                                ? null
                                                                : 'Enter a valid email',
                                                        onChanged: (val) {
                                                          setState(() =>
                                                              forgotEmail =
                                                                  val);
                                                        }),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          )),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Color(
                                                                      0xFFFFE98C)),
                                                          elevation:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                          double>(
                                                                      (states) =>
                                                                          0)),
                                                      onPressed: () async {
                                                        // Validation check
                                                        if (secondaryFormkey
                                                            .currentState!
                                                            .validate()) {
                                                          dynamic result =
                                                              await _auth
                                                                  .forgotPassword(
                                                                      forgotEmail);
                                                          Navigator.of(context)
                                                              .pop();
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                                return AlertDialog(
                                                                    title: Text(
                                                                        'Sent password reset email to ${forgotEmail}'));
                                                              });
                                                          if (result == null) {}
                                                        }
                                                      },
                                                      child: Text(
                                                          'Reset password',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF000000))),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        })
                                  },
                          ),
                        ),
                      ),
                      SizedBox(height: 12.5),
                      ElevatedButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                (MediaQuery.of(context).size.width * 0.85),
                                (MediaQuery.of(context).size.width * 0.1))),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFFFDD4b)),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        onPressed: () async {
                          // Validation check
                          if (_formKey.currentState!.validate()) {
                            dynamic result =
                                await _auth.signInEmail(email, password);
                            if (result == null) {
                              setState(() =>
                                  error = 'Invalid email and/or password');
                            }
                          }
                        },
                        child: Text('Sign In',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000))),
                      ),
                      SizedBox(height: 5.0),
                      ElevatedButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                (MediaQuery.of(context).size.width * 0.85),
                                (MediaQuery.of(context).size.width * 0.1))),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFFFDD4b)),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        onPressed: () async {
                          final provider =
                              Provider.of<AuthService>(context, listen: false);
                          provider.googleLogin();
                        },
                        child: Text('Sign In with Google',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000))),
                      ),
                      SizedBox(height: 5.0),
                      ElevatedButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                (MediaQuery.of(context).size.width * 0.85),
                                (MediaQuery.of(context).size.width * 0.1))),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFFFDD4b)),
                            elevation:
                                MaterialStateProperty.resolveWith<double>(
                                    (states) => 0)),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder<dynamic>(
                              pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) =>
                                  Register(),
                              transitionsBuilder: (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                              ) {
                                final Tween<Offset> offsetTween = Tween<Offset>(
                                    begin: Offset(1.0, 0.0),
                                    end: Offset(0.0, 0.0));
                                final Animation<Offset>
                                    slideInFromTheRightAnimation =
                                    offsetTween.animate(animation);
                                return SlideTransition(
                                    position: slideInFromTheRightAnimation,
                                    child: child);
                              },
                            ),
                          );
                          // widget.toggleSignIn();
                        },
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000))),
                      ),

                      SizedBox(
                        height: 5.0,
                      ),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ]),
              )),
        ),
      ]),
    );
  }
}
