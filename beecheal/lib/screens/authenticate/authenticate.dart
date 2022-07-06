import 'package:beecheal/screens/authenticate/register.dart';
import 'package:beecheal/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  // void toggleSignIn() {
  //   setState(() => showSignIn = !showSignIn);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/') {
          return PageRouteBuilder<dynamic>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                SignIn(),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              final Tween<Offset> offsetTween = Tween<Offset>(
                  begin: Offset(0.0, 0.0), end: Offset(-1.0, 0.0));
              final Animation<Offset> slideOutLeftAnimation =
                  offsetTween.animate(secondaryAnimation);
              return SlideTransition(
                  position: slideOutLeftAnimation, child: child);
            },
          );
        } else {
          // handle other routes here
          return null;
        }
      },
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFFFFAB00), centerTitle: true),
          colorScheme: ColorScheme(
              background: Color(0xFFFFE0B2),
              primary: Color(0xFFFFAB00),
              secondary: Color(0xFFFFDD4B),
              tertiary: Color(0xFFFFC95C),
              error: Colors.red,
              surface: Colors.white,
              onPrimary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.black,
              onSecondary: Colors.black,
              onError: Colors.black,
              brightness: Brightness.light),
          dialogBackgroundColor: Color(0xFFFFC95C),
          fontFamily: "Rubik",
          textTheme: TextTheme(
              button: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))),
    );
  }
}
