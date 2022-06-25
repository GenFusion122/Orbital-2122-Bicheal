class Occasion {
  String _id;
  String _title;
  DateTime _date;
  String _description;
  Occasion(this._id, this._title, this._date, this._description);

  String getId() {
    return this._id;
  }

  void setId(String id) {
    this._id = id;
  }

  String getTitle() {
    return this._title;
  }

  void setTitle(String title) {
    this._title = title;
  }

  DateTime getDate() {
    return this._date;
  }

  void setDate(DateTime date) {
    this._date = date;
  }

  String getDescription() {
    return this._description;
  }

  void setDescription(String description) {
    this._description = description;
  }
}
