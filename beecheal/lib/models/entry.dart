import 'package:beecheal/models/occasion.dart';
import 'package:flutter/cupertino.dart';

class Entry extends Occasion {
  String _body;
  int _sentiment;
  Entry(super._id, super._title, super._date, super._description, this._body,
      this._sentiment);

  String getBody() {
    return this._body;
  }

  void setBody(String body) {
    this._body = body;
  }

  int getSentiment() {
    return this._sentiment;
  }

  void setSentiment(int sentiment) {
    this._sentiment = sentiment;
  }
}
