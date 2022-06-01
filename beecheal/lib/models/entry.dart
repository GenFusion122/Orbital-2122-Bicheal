import 'package:beecheal/models/occasion.dart';
import 'package:flutter/cupertino.dart';

class Entry extends Occasion {
  String _body;
  Entry(super._id, super._title, super._date, super._description, this._body);

  getBody() {
    return this._body;
  }

  setBody(String body) {
    this._body = body;
  }
}
