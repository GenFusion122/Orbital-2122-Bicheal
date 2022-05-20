import 'package:beecheal/screens/home/home.dart';
import 'package:beecheal/screens/wrapper.dart';
import 'package:beecheal/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beecheal/services/auth.dart';
import 'package:provider/provider.dart';

class journalEntries extends StatelessWidget {
  const journalEntries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('journals skreen'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Align(
            alignment: Alignment.center,
            child: Text('<insert journal list here>')),
      ),
    );