import 'package:beecheal/models/occasion.dart';
import 'package:flutter/cupertino.dart';

class Entry extends Occasion {
  String body;
  Entry(super.id, super.title, super.date, super.description, this.body);
}
