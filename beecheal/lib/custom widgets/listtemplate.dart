import 'package:beecheal/custom%20widgets/tiletemplate.dart';
import 'package:flutter/material.dart';

class ListTemplate extends StatefulWidget {
  // const ListTemplate({Key? key}) : super(key: key);

  var list;
  String view;

  ListTemplate(this.list, this.view);

  @override
  State<ListTemplate> createState() => _ListTemplateState();
}

class _ListTemplateState extends State<ListTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return TileTemplate(widget.list[index], widget.view);
        });
  }
}
