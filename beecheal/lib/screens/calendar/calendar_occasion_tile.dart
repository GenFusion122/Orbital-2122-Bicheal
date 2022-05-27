import 'package:beecheal/models/occasion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class OccasionTile extends StatelessWidget {
  final Occasion occasion;
  OccasionTile(this.occasion);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            title: Text(occasion.title),
            subtitle: Text(occasion.description),
            trailing: Text(occasion.date.toString()),
            onTap: () {
              /*showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return OccasionView(occasion);
                  });*/
            },
          ),
        ));
  }
}
