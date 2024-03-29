import 'package:beecheal/screens/authenticate/authenticate.dart';
import '../models/task.dart';
import '../services/database.dart';
import 'authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'package:beecheal/models/userid.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserID?>(context);

    //return Home or Authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return StreamProvider<List<Task>?>.value(
          catchError: ((context, error) {}),
          value: DatabaseService().tasks,
          initialData: [],
          child: Home());
    }
  }
}
