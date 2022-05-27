import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/occasion.dart';
import 'calendar_occasion_tile.dart';

class OccasionList extends StatefulWidget {
  //const OccasionList({Key? key}) : super(key: key);

  @override
  State<OccasionList> createState() => _OccasionListState();
}

class _OccasionListState extends State<OccasionList> {
  @override
  Widget build(BuildContext context) {
    final occasion = Provider.of<List<Occasion>>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: occasion.length,
      itemBuilder: (context, index) {
        return OccasionTile(occasion[index]);
      },
    );
  }
}
