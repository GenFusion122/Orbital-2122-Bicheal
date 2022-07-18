import 'package:beecheal/custom%20widgets/hexagonalclipper.dart';
import 'package:beecheal/screens/authenticate/register.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:beecheal/custom widgets/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:hexagon/hexagon.dart';
import 'package:beecheal/custom widgets/loading.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math';

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
  final _secondaryFormkey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // loading screen
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // web build
      double scaleMin = min(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
      double scaleMax = min(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
      return ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: null,
          body: Stack(children: [
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  'assets/BzB.png',
                                  height: (scaleMin * 0.2),
                                  width: (scaleMin * 0.2),
                                ),
                              ),
                              SizedBox(height: scaleMin * 0.02),
                              // Email input
                              TextFormField(
                                  key: const Key('emailField'),
                                  style: TextStyle(
                                      fontSize: scaleMin * 0.04,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xff000000)),
                                  cursorColor: Color(0xff000000),
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      counterText: "",
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(10))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(10))),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(10)),
                                      )),
                                  validator: (val) =>
                                      EmailValidator.validate(val!)
                                          ? null
                                          : 'Enter a valid email',
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  }),
                              SizedBox(height: scaleMin * 0.02),
                              // Password input
                              TextFormField(
                                  key: const Key('passwordField'),
                                  style: TextStyle(
                                      fontSize: scaleMin * 0.04,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xff000000)),
                                  cursorColor: Color(0xff000000),
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      counterText: "",
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(10))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(10))),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(10)),
                                      )),
                                  validator: (val) => val!.length < 8
                                      ? 'Enter a password at least 8 characters long'
                                      : null,
                                  obscureText: true,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  }),
                              SizedBox(height: scaleMin * 0.0125),
                              Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  key: const Key('forgotPassword'),
                                  text: TextSpan(
                                    text: 'Forgot Password?',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: scaleMin * 0.032,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff000000)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  String forgotEmail = '';
                                                  return AlertDialog(
                                                    content: Form(
                                                      key: _secondaryFormkey,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          TextFormField(
                                                              key: const Key(
                                                                  'forgotEmail'),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      scaleMin *
                                                                          0.04,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Color(
                                                                      0xff000000)),
                                                              cursorColor: Color(
                                                                  0xff000000),
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "Email",
                                                                      counterText:
                                                                          "",
                                                                      enabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .black),
                                                                          borderRadius: const BorderRadius.all(const Radius.circular(
                                                                              10))),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.black),
                                                                          borderRadius: const BorderRadius.all(const Radius.circular(10))),
                                                                      border: UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.black),
                                                                        borderRadius: const BorderRadius
                                                                            .all(const Radius
                                                                                .circular(
                                                                            10)),
                                                                      )),
                                                              validator: (val) => EmailValidator.validate(val!) ? null : 'Enter a valid email',
                                                              onChanged: (val) {
                                                                setState(() =>
                                                                    forgotEmail =
                                                                        val);
                                                              }),
                                                          SizedBox(
                                                              height: scaleMin *
                                                                  0.0125),
                                                          ElevatedButton(
                                                            key: const Key(
                                                                'resetPassword'),
                                                            style: ButtonStyle(
                                                                minimumSize: MaterialStateProperty.all(Size(
                                                                    (MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.425),
                                                                    (scaleMin *
                                                                        0.1))),
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                )),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Color(
                                                                            0xFFFFE98C)),
                                                                elevation: MaterialStateProperty
                                                                    .resolveWith<double>(
                                                                        (states) =>
                                                                            0)),
                                                            onPressed:
                                                                () async {
                                                              // Validation check
                                                              if (_secondaryFormkey
                                                                  .currentState!
                                                                  .validate()) {
                                                                dynamic result =
                                                                    await _auth
                                                                        .forgotPassword(
                                                                            forgotEmail);
                                                                scaffoldMessengerKey.currentState!.showSnackBar(
                                                                    SnackBar(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                18.0)),
                                                                        elevation:
                                                                            0.0,
                                                                        backgroundColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary,
                                                                        content:
                                                                            Text(
                                                                          'Sent password reset email to ${forgotEmail}',
                                                                          style: TextStyle(
                                                                              fontSize: scaleMin * 0.028,
                                                                              fontWeight: FontWeight.w900,
                                                                              color: Color(0xff000000)),
                                                                        )));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                if (result ==
                                                                    null) {}
                                                              }
                                                            },
                                                            child: Text(
                                                                'Reset password',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        scaleMin *
                                                                            0.036,
                                                                    color: Color(
                                                                        0xFF000000))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })
                                          },
                                  ),
                                ),
                              ),
                              SizedBox(height: scaleMin * 0.0125),
                              ElevatedButton(
                                key: const Key('signIn'),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(
                                        (MediaQuery.of(context).size.width *
                                            0.425),
                                        (scaleMin * 0.1))),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFFFDD4b)),
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>((states) => 0)),
                                onPressed: () async {
                                  // Validation check
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.signInEmail(
                                        email, password);
                                    if (result == null) {
                                      setState(() {
                                        error = 'Invalid email and/or password';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                child: Text('Sign In',
                                    style: TextStyle(
                                        fontSize: scaleMin * 0.036,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff000000))),
                              ),
                              SizedBox(height: scaleMin * 0.005),
                              ElevatedButton(
                                key: const Key('signInGoogle'),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(
                                        (MediaQuery.of(context).size.width *
                                            0.425),
                                        (scaleMin * 0.1))),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFFFDD4b)),
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>((states) => 0)),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  final provider = Provider.of<AuthService>(
                                      context,
                                      listen: false);
                                  await provider.googleLogin();
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Text('Sign In with Google',
                                    style: TextStyle(
                                        fontSize: scaleMin * 0.036,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff000000))),
                              ),
                              SizedBox(height: scaleMin * 0.005),
                              ElevatedButton(
                                key: const Key('signUp'),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(
                                        (MediaQuery.of(context).size.width *
                                            0.425),
                                        (scaleMin * 0.1))),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFFFDD4b)),
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>((states) => 0)),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder<dynamic>(
                                      pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) =>
                                          Register(),
                                      transitionsBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        final Tween<Offset> offsetTween =
                                            Tween<Offset>(
                                                begin: Offset(1.0, 0.0),
                                                end: Offset(0.0, 0.0));
                                        final Animation<Offset>
                                            slideInFromTheBotAnimation =
                                            offsetTween.animate(animation);
                                        return SlideTransition(
                                            position:
                                                slideInFromTheBotAnimation,
                                            child: child);
                                      },
                                    ),
                                  );
                                  // widget.toggleSignIn();
                                },
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        fontSize: scaleMin * 0.036,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff000000))),
                              ),

                              SizedBox(
                                height: scaleMin * 0.005,
                              ),
                              Text(error,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: scaleMin * 0.028)),
                            ]),
                      )),
            ),
          ]),
        ),
      );
    } else {
      //android build
      return ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xFFFFE0B2),
          appBar: null,
          body: Stack(children: [
            Positioned(
              left: -(MediaQuery.of(context).size.width * 0.45),
              top: 0.0,
              child: HexagonWidget.flat(
                color: Color.fromRGBO(255, 171, 0, 1),
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  'assets/BzB.png',
                                  height:
                                      (MediaQuery.of(context).size.width * 0.5),
                                  width:
                                      (MediaQuery.of(context).size.width * 0.5),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              // Email input
                              TextFormField(
                                  key: const Key('emailField'),
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
                                  key: const Key('passwordField'),
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
                                  key: const Key('forgotPassword'),
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
                                                builder:
                                                    (BuildContext context) {
                                                  String forgotEmail = '';
                                                  return ClipPath(
                                                    clipper: HexagonalClipper(),
                                                    child: Material(
                                                      color: Color(0xFFFFC95C),
                                                      child: Center(
                                                        child: Container(
                                                          alignment:
                                                              FractionalOffset(
                                                                  0.5, 0.375),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                          child: Form(
                                                            key:
                                                                _secondaryFormkey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                TextFormField(
                                                                    key: const Key(
                                                                        'forgotEmail'),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        color: Color(
                                                                            0xff000000)),
                                                                    cursorColor:
                                                                        Color(
                                                                            0xff000000),
                                                                    decoration:
                                                                        textInputDecoration.copyWith(
                                                                            hintText:
                                                                                'Email'),
                                                                    validator: (val) => EmailValidator.validate(
                                                                            val!)
                                                                        ? null
                                                                        : 'Enter a valid email',
                                                                    onChanged:
                                                                        (val) {
                                                                      setState(() =>
                                                                          forgotEmail =
                                                                              val);
                                                                    }),
                                                                ElevatedButton(
                                                                  key: const Key(
                                                                      'resetPassword'),
                                                                  style: ButtonStyle(
                                                                      minimumSize: MaterialStateProperty.all(Size((MediaQuery.of(context).size.width * 0.75), (MediaQuery.of(context).size.width * 0.1))),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      )),
                                                                      backgroundColor: MaterialStateProperty.all(Color(0xFFFFE98C)),
                                                                      elevation: MaterialStateProperty.resolveWith<double>((states) => 0)),
                                                                  onPressed:
                                                                      () async {
                                                                    // Validation check
                                                                    if (_secondaryFormkey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      dynamic
                                                                          result =
                                                                          await _auth
                                                                              .forgotPassword(forgotEmail);
                                                                      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                                                                          elevation: 0.0,
                                                                          backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                          content: Text(
                                                                            'Sent password reset email to ${forgotEmail}',
                                                                            style: TextStyle(
                                                                                fontSize: 12.0,
                                                                                fontWeight: FontWeight.w900,
                                                                                color: Color(0xff000000)),
                                                                          )));
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      if (result ==
                                                                          null) {}
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      'Reset password',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Color(0xFF000000))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })
                                          },
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.5),
                              ElevatedButton(
                                key: const Key('signIn'),
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
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>((states) => 0)),
                                onPressed: () async {
                                  // Validation check
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.signInEmail(
                                        email, password);
                                    if (result == null) {
                                      setState(() {
                                        error = 'Invalid email and/or password';
                                        loading = false;
                                      });
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
                                key: const Key('signInGoogle'),
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
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>((states) => 0)),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  final provider = Provider.of<AuthService>(
                                      context,
                                      listen: false);
                                  await provider.googleLogin();
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Text('Sign In with Google',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff000000))),
                              ),
                              SizedBox(height: 5.0),
                              ElevatedButton(
                                key: const Key('signUp'),
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
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>((states) => 0)),
                                onPressed: () async {
                                  print(MediaQuery.of(context).size.height);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder<dynamic>(
                                      pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) =>
                                          Register(),
                                      transitionsBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        final Tween<Offset> offsetTween =
                                            Tween<Offset>(
                                                begin: Offset(1.0, 0.0),
                                                end: Offset(0.0, 0.0));
                                        final Animation<Offset>
                                            slideInFromTheRightAnimation =
                                            offsetTween.animate(animation);
                                        return SlideTransition(
                                            position:
                                                slideInFromTheRightAnimation,
                                            child: child);
                                      },
                                    ),
                                  );
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
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.0)),
                            ]),
                      )),
            ),
          ]),
        ),
      );
    }
  }
}
