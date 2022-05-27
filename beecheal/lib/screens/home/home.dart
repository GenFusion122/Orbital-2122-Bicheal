import 'package:beecheal/custom%20widgets/listtemplate.dart';
import 'package:beecheal/models/task.dart';
import 'package:beecheal/screens/todo_list/todo_task_edit.dart';
import 'package:beecheal/screens/todo_list/todo_task_view.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beecheal/models/userid.dart';
import '../../custom widgets/custombuttons.dart';
import 'package:beecheal/models/occasion.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home!'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              icon: Icon(Icons.person),
              style: TextButton.styleFrom(primary: Colors.brown[500]),
              label: Text('Sign Out'),
              onPressed: () async {
                await _auth.signOut();
                setState(() {});
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(children: [
              Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ListTemplate(
                      Provider.of<List<Task>>(context), 'TaskView')),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: FloatingActionButton(
                        child: Icon(Icons.add),
                        backgroundColor: Colors.amber[400],
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TaskEditScreen(
                                    task: Task(
                                      "",
                                      "",
                                      DateTime(2999, 12, 12, 23, 59),
                                      "",
                                      DateTime(2999, 12, 12, 23, 59),
                                    ),
                                    textPrompt: 'Create');
                              });
                        }),
                  ),
                ),
              )
            ]),
          ),
          Expanded(
              flex: 2,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                  ])),
          Expanded(
              flex: 2,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("Custom card!"),
                    ),
                  ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OrangeNavButton("/statistics", "statistics", context),
              OrangeNavButton("/calendar", "calendar", context),
              OrangeNavButton("/journalEntries", "journal", context),
            ],
          ),
        ],
      ),
    );
  }
}
